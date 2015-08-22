class BatchImportsController < ApplicationController
  before_action :authenticate_user!
  before_filter :load_batch_import, only: [:download]

  def download
    send_file "#{Rails.root}/uploads/batch_import/import_file/#{@batch_import.id}/#{File.basename(@batch_import.import_file.url)}"
  end

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
    def load_batch_import
      @batch_import = BatchImport.find(params[:id])
    end

    def batch_import_params
      params.require(:batch_import).permit(:imported_at, :import_file)
    end
end