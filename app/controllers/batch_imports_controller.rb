class BatchImportsController < ApplicationController
  before_action :authenticate_user!

  def new
    @batch_import = BatchImport.new
  end

  def create
    @batch_import = BatchImport.new(batch_import_params)
    if @batch_import.save
      Delayed::Job.enqueue ProcessBatchImportJob.new(@batch_import.id)
      redirect_to pathology_cases_url
    else
      render "new"
    end
  end


  private
    def batch_import_params
      params.require(:batch_import).permit(:imported_at, :import_file)
    end
end
