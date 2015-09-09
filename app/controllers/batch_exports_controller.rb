class BatchExportsController < ApplicationController
  helper_method :sort_column, :sort_direction
  before_action :authenticate_user!

  def new
    authorize BatchExport.new
    session[:index_history] = request.url
    @abstraction_schema_has_cancer_histology = Abstractor::AbstractorAbstractionSchema.where(predicate: 'has_cancer_histology').first
    @abstraction_schema_has_cancer_site = Abstractor::AbstractorAbstractionSchema.where(predicate: 'has_cancer_site').first
    options = {}
    options[:sort_column] = sort_column
    options[:sort_direction] = sort_direction
    @abstractor_abstraction_groups = SqlAudit.find_and_audit(
      current_user.email,
      BatchExport.find_exportable_primary_cancer_abstractor_abstraction_groups(options)
    )
    respond_to do |format|
      format.html { @abstractor_abstraction_groups = @abstractor_abstraction_groups.paginate(per_page: 10, page: params[:page]) }
    end
  end

  def create
    authorize BatchExport.new
    @batch_export = nil
    abstractor_abstraction_groups = BatchExport.find_exportable_primary_cancer_abstractor_abstraction_groups
    if abstractor_abstraction_groups.any?
      BatchExport.transaction do
        @batch_export = BatchExport.new(exported_at: Time.zone.now)
        abstractor_abstraction_groups.each do |abstractor_abstraction_group|
          @batch_export.batch_export_details.build(abstractor_abstraction_group: abstractor_abstraction_group)
        end
        @batch_export.save!
      end
    end
    redirect_to batch_export_path(@batch_export)
  end

  def show
    session[:index_history] = request.url
    options = {}
    options[:sort_column] = sort_column
    options[:sort_direction] = sort_direction
    @batch_export = SqlAudit.find_and_audit(
      current_user.email,
      BatchExport.where(id: params[:id])
    ).first

    authorize @batch_export

    if params[:export]
      params.delete(:export)
      params.merge!({ format: 'text' })
      redirect_to batch_export_path(params) and return
    end

    @abstractor_abstraction_groups = @batch_export.load_primary_cancer_abstractor_abstraction_groups(options)
    respond_to do |format|
      format.html { @abstractor_abstraction_groups = @abstractor_abstraction_groups.paginate(per_page: 10, page: params[:page]) }
      format.text { send_data BatchExport.to_metriq(@abstractor_abstraction_groups), filename: "metriq_#{@batch_export.id}_#{DateTime.now}.txt" }
    end
  end

  private

    def sort_column
      ['accession_number', 'collection_date', 'histology', 'site'].include?(params[:sort]) ? params[:sort] : "collection_date"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end
end