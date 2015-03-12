class PathologyCasesController < ApplicationController
  def index
    params[:filter] ||= Abstractor::Enum::ABSTRACTION_STATUS_NEEDS_REVIEW
    @pathology_cases = PathologyCase.search_across_fields(params[:search]).by_abstractor_abstraction_status(params[:filter]).by_encounter_date(params[:date_from], params[:date_to]).order('encounter_date ASC').paginate(:per_page => 10, :page => params[:page])
  end

  def edit
    @pathology_case = PathologyCase.find(params[:id])
    respond_to do |format|
      format.html
    end
  end

  def import
    PathologyCase.import(params[:file])
    redirect_to root_url, notice: "Pathology Cases imported."
  end

  def upload
  end
end