class BatchImportsController < ApplicationController
  before_action :audit_activity, :authenticate_user!
  before_action :load_batch_import, only: [:download]

  def new
    @batch_import = BatchImport.new
    authorize @batch_import
  end

  def create
    @batch_import = BatchImport.new(batch_import_params)
    authorize @batch_import
    if @batch_import.save
      Delayed::Job.enqueue ProcessBatchImportJob.new(@batch_import.id)
      redirect_to pathology_cases_url
    else
      render "new"
    end
  end

  def download
    send_file "#{Rails.root}/uploads/batch_import/import_file/#{@batch_import.id}/#{File.basename(@batch_import.import_file.url)}"
  end

  private
    def load_batch_import
      @batch_import = BatchImport.find(params[:id])
    end

    def batch_import_params
      params.fetch(:batch_import, {}).permit(:imported_at, :import_file)
    end
end