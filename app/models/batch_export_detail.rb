class BatchExportDetail < ActiveRecord::Base
  include Abstractor::Methods::Models::SoftDelete
  belongs_to :batch_export
  belongs_to :abstractor_abstraction_group, :class_name => Abstractor::AbstractorAbstractionGroup
end