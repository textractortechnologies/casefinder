class ProcessBatchImportJob < Struct.new(:batch_import_id)
  def enqueue(job)
    job.delayed_reference_id   = batch_import_id
    job.delayed_reference_type = 'BatchImport'
    job.save!
  end

  def error(job, exception)
    # Send email notification / alert / alarm
  end

  def failure(job)
    # Send email notification / alert / alarm / SMS / call ... whatever
  end

  def perform
    batch_import = BatchImport.find(batch_import_id)
    batch_import.import
  end
end