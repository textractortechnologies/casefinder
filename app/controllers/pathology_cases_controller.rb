class PathologyCasesController < ApplicationController
  helper_method :sort_column, :sort_direction
  before_action :authenticate_user!

  def back_to_pathology_cases_index
    session[:index_history] || pathology_cases_url
  end

  def index
    session[:index_history] = request.url unless params[:next_case]
    @filter_statuses = Abstractor::Enum::ABSTRACTION_WORKFLOW_STATUSES
    @filter_by = PathologyCase.workflow_status_whodunnit_list.all.map(&:workflow_status_whodunnit).sort
    @flag_statuses = { "flagged" => Abstractor::Enum::ABSTRACTION_SUGGESTION_TYPE_SUGGESTED, "not flagged" => Abstractor::Enum::ABSTRACTION_SUGGESTION_TYPE_UNKNOWN }
    @abstraction_schema_site = Abstractor::AbstractorAbstractionSchema.where(predicate: 'has_cancer_site').first
    @abstraction_schema_histology = Abstractor::AbstractorAbstractionSchema.where(predicate: 'has_cancer_histology').first
    @sites = Abstractor::AbstractorObjectValue.joins(:abstractor_abstraction_schema_object_values).where(abstractor_abstraction_schema_object_values: { abstractor_abstraction_schema_id: @abstraction_schema_site } ).order('vocabulary_code ASC').map { |s| { label: s.value , category: 'Site' }  }
    @histologies = Abstractor::AbstractorObjectValue.joins(:abstractor_abstraction_schema_object_values).where(abstractor_abstraction_schema_object_values: { abstractor_abstraction_schema_id: @abstraction_schema_histology } ).order('vocabulary_code ASC').map { |h| { label: h.value , category: 'Histology' }  }
    params[:filter] ||= Abstractor::Enum::ABSTRACTION_WORKFLOW_STATUS_PENDING
    params[:filter_by] = nil if params[:filter_by].blank?
    params[:suggestion_filter] ||= "flagged"

    params[:page]||= 1
    options = {}
    options[:sort_column] = sort_column
    options[:sort_direction] = sort_direction
    abstractor_abstraction_schema_cancer_histology = PathologyCase.abstractor_abstraction_schemas.detect { |abstractor_abstraction_schema| abstractor_abstraction_schema.display_name = 'Cancer Histology' }
    @pathology_cases = SqlAudit.find_and_audit(
      current_user.email,
      PathologyCase.search_across_fields(params[:search], options).by_abstraction_workflow_status(params[:filter], { workflow_status_whodunnit: params[:filter_by] }).by_abstractor_suggestion_type(@flag_statuses[params[:suggestion_filter]], abstractor_abstraction_schemas: abstractor_abstraction_schema_cancer_histology).by_collection_date(params[:date_from], params[:date_to])
    )

    if params[:export]
      params.delete(:export)
      params.merge!({ format: 'text' })
      redirect_to pathology_cases_path(params) and return
    end

    if params[:next_case]
      index = params[:index].to_i
      pathology_cases = @pathology_cases.select("DISTINCT #{sort_column}, pathology_cases.id").map(&:id)
      record_history
      if pathology_cases.any?
        if pathology_cases.size > (index + 1)
          if pathology_cases[index] == params[:previous_pathology_case_id].to_i
            index = index + 1
          end
          next_case = pathology_cases[index]
        else
          index = 0
          next_case = pathology_cases[0]
        end

        redirect_to edit_pathology_case_url(next_case, index: index) and return
      else
        redirect_to pathology_cases_path and return
      end
    end

    respond_to do |format|
      format.html { @pathology_cases = @pathology_cases.paginate(per_page: 10, page: params[:page]); record_history }
      format.csv { send_data PathologyCase.to_csv(@pathology_cases), filename: "metriq_#{DateTime.now}.csv" }
      format.text { send_data PathologyCase.to_metriq(@pathology_cases), filename: "metriq_#{DateTime.now}.txt" }
    end
  end

  def edit
    unless params[:last_case]
      session[:last_pathology_case] ||= []
      if session[:current_pathology_case]
        session[:last_pathology_case] << session[:current_pathology_case]
      end
      session[:current_pathology_case] = params[:id]
    end

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
      session[:history].gsub!("&next_case=true","")
      session[:history].gsub!(/&index=\d/,"")
      session[:history].gsub!(/&previous_pathology_case_id=\d/,"")
      session[:history] = session[:history] + (session[:history].include?('?') ? "&next_case=true&index=#{params[:index]}&previous_pathology_case_id=#{params[:previous_pathology_case_id]}" : "?&next_case=true&index=#{params[:index]}&previous_pathology_case_id=#{params[:previous_pathology_case_id]}")
      redirect_to session[:history] and return
    else
      redirect_to pathology_cases_url and return
    end
  end

  def last_pathology_case
    if session[:last_pathology_case].any?
      redirect_to edit_pathology_case_url(session[:last_pathology_case].pop, last_case: true) and return
    else
      redirect_to pathology_cases_url and return
    end
  end

  def countdown
    @countdown = PathologyCase.countdown

    respond_to do |format|
      format.json { render json: { countdown: @countdown } }
    end
  end

  private
    def sort_column
      PathologyCase.column_names.concat(['suggested_sites', 'suggested_histologies']).include?(params[:sort]) ? params[:sort] : "collection_date"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end
end