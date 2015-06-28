class ProcessPathologyCaseJob < Struct.new(:pathology_case_id)
  def enqueue(job)
      job.delayed_reference_id   = pathology_case_id
      job.delayed_reference_type = 'PathologyCase'
      job.save!
  end

  def error(job, exception)
    # Send email notification / alert / alarm
  end

  def failure(job)
    # Send email notification / alert / alarm / SMS / call ... whatever
  end

  def perform
    pathology_case = PathologyCase.find(pathology_case_id)
    pathology_case.abstract
  end
end
