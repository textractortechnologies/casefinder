class RakeMailer < ApplicationMailer
  default from: Rails.configuration.case_finder_config[:sender_address]
  default to:   Rails.configuration.case_finder_config[:exception_recipients]

   def orphan_sweep(orphan_pathology_case_ids, reminaing_orphan_pathology_case_ids)
     @orphan_pathology_case_ids = orphan_pathology_case_ids
     @reminaing_orphan_pathology_case_ids = reminaing_orphan_pathology_case_ids
     mail(subject: "[#{Rails.env}] Case Finder Orphan Sweep Report")
   end

   def orphan_sweep_exception(error)
     @error = error.message
     @backtrace = error.backtrace.join("\n")
     mail(subject: "[#{Rails.env}] Case Finder Orphan Sweep Exception")
   end

   def integrity_check(successful_batch_import_count, pathology_case_count, failed_batch_import_count, orphan_pathology_case_count)
     @successful_batch_import_count = successful_batch_import_count
     @pathology_case_count = pathology_case_count
     @failed_batch_import_count = failed_batch_import_count
     @orphan_pathology_case_count = orphan_pathology_case_count
     mail(subject: "[#{Rails.env}] Case Finder Integrity Check")
   end
 end