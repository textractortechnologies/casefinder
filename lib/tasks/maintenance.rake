namespace :maintenance do
  desc "Orphan Sweep"
  task(orphan_sweep: :environment) do  |t, args|
    begin
      seconds_ago = 1800
      orphan_pathology_case_ids = unabstracted_pathology_cases_ids(seconds_ago)
      pathology_cases = PathologyCase.where(id: orphan_pathology_case_ids)
      pathology_cases.each do |pathology_case|
        pathology_case.abstract
        sleep(5)
      end
      reminaing_orphan_pathology_case_ids = unabstracted_pathology_cases_ids(seconds_ago)

      if orphan_pathology_case_ids.any?
        RakeMailer.orphan_sweep(orphan_pathology_case_ids, reminaing_orphan_pathology_case_ids).deliver_now
      end
    rescue Exception => e
      Rails.logger.info('maintenance:orphan_sweep rake task unhandled error.  Please fix.')
      Rails.logger.info(e.message)
      Rails.logger.info(e.class)
      Rails.logger.info(e.backtrace)
      RakeMailer.rake_exception(e).deliver_now
    end
  end

  desc "Integrity check"
  task(integrity_check: :environment) do  |t, args|
    begin
      successful_batch_import_count = BatchImport.where('created_at >= ? AND pathology_case_id IS NOT NULL', Date.today-3).count
      failed_batch_import_count = BatchImport.where('pathology_case_id IS NULL AND created_at >=?', Date.today-3).count
      pathology_case_count = PathologyCase.where('created_at >= ?', Date.today-3).count
      orphan_pathology_case_count = unabstracted_pathology_cases_ids(0).size
      RakeMailer.integrity_check(successful_batch_import_count, pathology_case_count, failed_batch_import_count, orphan_pathology_case_count).deliver_now
    rescue Exception => e
      Rails.logger.info('maintenance:integrity_check rake task unhandled error.  Please fix.')
      Rails.logger.info(e.message)
      Rails.logger.info(e.class)
      Rails.logger.info(e.backtrace)
      RakeMailer.rake_exception(e).deliver_now
    end
  end
end

def unabstracted_pathology_cases_ids(seconds_ago)
  cutoff_datetime = DateTime.now.ago(seconds_ago)
  PathologyCase.where('pathology_cases.created_at < ?', cutoff_datetime).joins("join abstractor_abstractions on abstractor_abstractions.about_id = pathology_cases.id and abstractor_abstractions.about_type = 'PathologyCase'").where("not exists(select 1 from abstractor_suggestions where abstractor_abstractions.id = abstractor_suggestions.abstractor_abstraction_id)").distinct('pathology_cases.id').all.map(&:id)
end