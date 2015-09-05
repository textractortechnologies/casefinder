module Abstractor
  module AbstractorAbstractionsControllerCustomMethods
  end

  class AbstractorAbstractionsController < ApplicationController
    include Abstractor::Methods::Controllers::AbstractorAbstractionsController
    include Abstractor::AbstractorAbstractionsControllerCustomMethods
    before_action :authenticate_user!

    def update_wokflow_status
      abstraction_workflow_status = params[:abstraction_workflow_status]
      if abstraction_workflow_status == Abstractor::Enum::ABSTRACTION_WORKFLOW_STATUS_PENDING
        @about = params[:about_type].constantize.find(params[:about_id])
        batch_export_details = []
        @about.abstractor_abstraction_groups.each do |abstractor_abstraction_group|
          batch_export_details << BatchExportDetail.where(abstractor_abstraction_group_id: abstractor_abstraction_group.id).first
        end

        Abstractor::AbstractorAbstraction.transaction do
          batch_export_details.compact.each do |batch_export_detail|
            batch_export_detail.soft_delete!
          end
        end
      end
      super
    end
  end
end