class BatchExportDetail < ActiveRecord::Base
  belongs_to :batch_export
  belongs_to :abstractor_abstraction_group, :class_name => Abstractor::AbstractorAbstractionGroup
end