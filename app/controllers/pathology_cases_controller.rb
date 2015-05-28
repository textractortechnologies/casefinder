class PathologyCasesController < ApplicationController
  helper_method :sort_column, :sort_direction
  before_action :authenticate_user!
  def index
    @filter_statuses = Abstractor::Enum::ABSTRACTION_STATUSES.reject { |s| s == Abstractor::Enum::ABSTRACTION_STATUS_ACTUALLY_ANSWERED }
    @flag_statuses = { "flagged" => Abstractor::Enum::ABSTRACTION_SUGGESTION_TYPE_SUGGESTED, "not flagged" => Abstractor::Enum::ABSTRACTION_SUGGESTION_TYPE_UNKNOWN }
    @abstraction_schema_site = Abstractor::AbstractorAbstractionSchema.where(predicate: 'has_cancer_site').first
    @abstraction_schema_histology = Abstractor::AbstractorAbstractionSchema.where(predicate: 'has_cancer_histology').first
    @sites = Abstractor::AbstractorObjectValue.joins(:abstractor_abstraction_schema_object_values).where(abstractor_abstraction_schema_object_values: { abstractor_abstraction_schema_id: @abstraction_schema_site } ).order('vocabulary_code ASC').map { |s| { label: s.value , category: 'Site' }  }
    @histologies = Abstractor::AbstractorObjectValue.joins(:abstractor_abstraction_schema_object_values).where(abstractor_abstraction_schema_object_values: { abstractor_abstraction_schema_id: @abstraction_schema_histology } ).order('vocabulary_code ASC').map { |h| { label: h.value , category: 'Histology' }  }
    params[:filter] ||= Abstractor::Enum::ABSTRACTION_STATUS_NEEDS_REVIEW
    params[:suggestion_filter] ||= "flagged"
    options = {}
    options[:sort_column] = sort_column
    options[:sort_direction] = sort_direction
    abstractor_abstraction_schema_cancer_histology = PathologyCase.abstractor_abstraction_schemas.detect { |abstractor_abstraction_schema| abstractor_abstraction_schema.display_name = 'Cancer Histology' }
    @pathology_cases = SqlAudit.find_and_audit(
      current_user.email,
      PathologyCase.search_across_fields(params[:search], options).by_abstractor_abstraction_status(params[:filter]).by_abstractor_suggestion_type(@flag_statuses[params[:suggestion_filter]], abstractor_abstraction_schemas: abstractor_abstraction_schema_cancer_histology).by_encounter_date(params[:date_from], params[:date_to])
    )

    if params[:export]
      params.delete(:export)
      params.merge!({ format: 'text' })
      redirect_to pathology_cases_path(params) and return
    end

    if params[:next_case]
      if @pathology_cases.any?
        redirect_to edit_pathology_case_url(@pathology_cases.first) and return
      else
        redirect_to pathology_cases_path and return
      end
    end

    respond_to do |format|
      format.html { @pathology_cases = @pathology_cases.paginate(:per_page => 10, :page => params[:page]); record_history }
      format.csv { send_data PathologyCase.to_csv(@pathology_cases), filename: "metriq_#{DateTime.now}.csv" }
      format.text { send_data PathologyCase.to_metriq(@pathology_cases), filename: "metriq_#{DateTime.now}.txt" }
    end
  end

  def edit
    @pathology_case = SqlAudit.find_and_audit(
      current_user.email,
      PathologyCase.where(id: params[:id])
    ).first

    respond_to do |format|
      format.html
    end
  end

  def import
    PathologyCase.import(params[:file])
    redirect_to pathology_cases_url, notice: "Pathology Cases imported."
  end

  def upload
  end

  def next_pathology_case
    if session[:history]
      session[:history] = session[:history] + (session[:history].include?('?') ? '&next_case=true' : '?&next_case=true')
      redirect_to session[:history] and return
    else
      redirect_to pathology_cases_url and return
    end
  end

  private

    def sort_column
      PathologyCase.column_names.concat(['suggested_sites', 'suggested_histologies']).include?(params[:sort]) ? params[:sort] : "encounter_date"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end
end