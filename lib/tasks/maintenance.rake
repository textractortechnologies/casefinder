# select count(distinct pc.accession_number)
# from pathology_cases pc join abstractor_abstractions aa on pc.id = aa.about_id
#                         join abstractor_suggestions sug on aa.id = sug.abstractor_abstraction_id
#                         join abstractor_subjects sub on aa.abstractor_subject_id = sub.id
#                         join abstractor_abstraction_schemas sh on sub.abstractor_abstraction_schema_id = sh.id
# where sh.predicate = 'has_cancer_histology'
# and sug.unknown = true
# SELECT DISTINCT [pathology_cases].*
# FROM [pathology_cases] join abstractor_abstractions on abstractor_abstractions.about_id = pathology_cases.id and abstractor_abstractions.about_type = 'PathologyCase'
# WHERE (pathology_cases.created_at < '05-08-2017 14:55:29.446')
# AND (not exists(select 1 from abstractor_suggestions
#                 where abstractor_abstractions.id = abstractor_suggestions.abstractor_abstraction_id)
# )
# select DISTINCT pc.accession_number
#      , pc.collection_date
#      , sh.predicate
#      , sug.suggested_value
#      , sug.unknown
# from pathology_cases pc join abstractor_abstractions aa on pc.id = aa.about_id
#                         join abstractor_suggestions sug on aa.id = sug.abstractor_abstraction_id
#                         join abstractor_subjects sub on aa.abstractor_subject_id = sub.id
#                         join abstractor_abstraction_schemas sh on sub.abstractor_abstraction_schema_id = sh.id
#                         join abstractor_suggestion_sources src on sug.id = src.abstractor_suggestion_id
# where pc.created_at >= '5/8/2017'
# order by pc.accession_number, sh.predicate, sug.suggested_value

# select DISTINCT pc.accession_number
#      , pc.collection_date
#      , sh.predicate
#      , sug.suggested_value
#      , sug.unknown
#      , src.*
# from pathology_cases pc join abstractor_abstractions aa on pc.id = aa.about_id
#                         join abstractor_suggestions sug on aa.id = sug.abstractor_abstraction_id
#                         join abstractor_subjects sub on aa.abstractor_subject_id = sub.id
#                         join abstractor_abstraction_schemas sh on sub.abstractor_abstraction_schema_id = sh.id
#                         join abstractor_suggestion_sources src on sug.id = src.abstractor_suggestion_id
# where pc.created_at >= '5/08/2017'
# --and pc.accession_number = '?'
# order by pc.accession_number, sh.predicate, sug.suggested_value


# --production
# select  pc.accession_number
#      , pc.collection_date
#      , sh.predicate
#      , sug.suggested_value
#      , sug.unknown
#      , src.*
# from pathology_cases pc join abstractor_abstractions aa on pc.id = aa.about_id
#                         join abstractor_suggestions sug on aa.id = sug.abstractor_abstraction_id
#                         join abstractor_subjects sub on aa.abstractor_subject_id = sub.id
#                         join abstractor_abstraction_schemas sh on sub.abstractor_abstraction_schema_id = sh.id
#                         join abstractor_suggestion_sources src on sug.id = src.abstractor_suggestion_id
# where pc.created_at >= '4/21/2017'
# and pc.accession_number = '?'
# order by pc.accession_number, sh.predicate, sug.suggested_value

namespace :maintenance do
  desc "Compare rule effects"
  task(compare_rule_effects: :environment) do  |t, args|
    production_pathology_cases = CSV.new(File.open('lib/setup/data/rules/production_pathology_cases.txt'), :headers => true, :col_sep =>"\t", :return_headers => false)
    test_pathology_cases = CSV.new(File.open('lib/setup/data/rules/test_pathology_cases.txt'), :headers => true, :col_sep =>"\t", :return_headers => false)
    # production_pathology_cases = CSV.new(File.open('lib/setup/data/rules/production_pathology_cases.csv'), headers: true, col_sep: ",", return_headers: false,  quote_char: "\"")
    # test_pathology_cases = CSV.new(File.open('lib/setup/data/rules/test_pathology_cases.csv'), headers: true, col_sep: ",", return_headers: false,  quote_char: "\"")

    production_pathology_cases = production_pathology_cases.map { |production_pathology_case| production_pathology_case.to_hash }
    test_pathology_cases = test_pathology_cases.map { |test_pathology_case| test_pathology_case.to_hash }
    accession_numbers = production_pathology_cases.map { |production_pathology_case| production_pathology_case.to_hash['accession_number'] }
    accession_numbers.uniq!

    File.open('C:\Users\gurleym1\Desktop\compare_rule_effects.txt', "w") do |f|
    # File.open('lib/setup/data/rules/compare_rule_effects.txt', "w") do |f|
      accession_numbers.each do |accession_number|
        f.write("BEGIN------------------------------------------------------\n")
        f.write("Looking at: \n")
        f.write("#{accession_number}\n")
        p = production_pathology_cases.select { |production_pathology_case| production_pathology_case['accession_number'] == accession_number }
        t = test_pathology_cases.select { |test_pathology_case| test_pathology_case['accession_number'] == accession_number }

        if p == t
          f.write("Same!\n")
          f.write("Here are the suggestions for both test and production:\n")
          p.each do |ep|
           f.write("#{ep}\n")
          end
        else
          f.write("Different!\n")
          f.write("Here are the suggestions for production:\n")
          p.each do |ep|
            f.write("#{ep}\n")
          end
          f.write("Here are the suggestions for test:\n")
          t.each do |et|
            f.write("#{et}\n")
          end

          production_extras = p - t

          if production_extras.any?
            f.write("Here are the suggestions in production not in test:\n")
            production_extras.each do |production_extra|
              f.write("#{production_extra}\n")
            end
          end

          test_extras = t - p

          if test_extras.any?
            f.write("Here are the suggestions in test not in production:\n")
            test_extras.each do |test_extra|
              f.write("#{test_extra}\n")
            end
          end
        end
        f.write("END------------------------------------------------------\n")
        f.write("\n")
      end
    end
  end

  desc "Orphan Sweep"
  task(orphan_sweep: :environment) do  |t, args|
    begin
      seconds_ago = 1800
      orphan_pathology_case_ids = unabstracted_pathology_cases_ids(seconds_ago)
      pathology_cases = PathologyCase.where(id: orphan_pathology_case_ids)
      pathology_cases.each do |pathology_case|
        pathology_case.abstract_multiple
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
      days_ago = 3
      successful_batch_import_count = BatchImport.where('created_at >= ? AND pathology_case_id IS NOT NULL', Date.today-days_ago).count
      failed_batch_import_count = BatchImport.where('pathology_case_id IS NULL AND created_at >=?', Date.today-days_ago).count
      pathology_case_count = PathologyCase.where('created_at >= ?', Date.today-days_ago).count
      orphan_pathology_case_count = unabstracted_pathology_cases_ids(0).size
      successful_batch_import_order_count = BatchImportOrder.where('created_at >= ? AND patient_id IS NOT NULL', Date.today-days_ago).count
      failed_batch_import_order_count = BatchImportOrder.where('patient_id IS NULL AND created_at >=?', Date.today-days_ago).count
      RakeMailer.integrity_check(successful_batch_import_count, pathology_case_count, failed_batch_import_count, orphan_pathology_case_count, successful_batch_import_order_count, failed_batch_import_order_count).deliver_now
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