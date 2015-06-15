module Abstractor
  module AbstractorAbstractionsControllerCustomMethods
    def index
      super
    end

    def show
      super
    end

    def edit
      super
    end

    def update
      super
    end

    def update_all
      abstractor_abstraction_value = params[:abstractor_abstraction_value]
      case abstractor_abstraction_value
      when Abstractor::Enum::ABSTRACTION_OTHER_VALUE_TYPE_UNKNOWN
        unknown = true
        not_applicable = nil
      when Abstractor::Enum::ABSTRACTION_OTHER_VALUE_TYPE_NOT_APPLICABLE
        unknown = nil
        not_applicable = true
      end

      @about = params[:about_type].constantize.find(params[:about_id])
      @about.abstractor_abstractions.each do |abstractor_abstraction|
        Abstractor::AbstractorAbstraction.transaction do |variable|
          abstractor_abstraction.abstractor_suggestions.each do |abstractor_suggestion|
            if abstractor_suggestion.abstractor_suggestion_sources.not_deleted.empty?
              abstractor_suggestion.destroy!
            end
          end

          abstractor_suggestion = abstractor_abstraction.abstractor_subject.suggest(abstractor_abstraction, nil, nil, nil, nil, nil, nil, nil, nil, unknown, not_applicable, nil, nil)
          abstractor_suggestion.accepted = true
          abstractor_suggestion.save!
        end
      end
      respond_to do |format|
        format.html { redirect_to main_app.next_pathology_case_pathology_cases_path(index: params[:index], previous_pathology_case_id: params[:previous_pathology_case_id]) }
      end
    end
  end

  class AbstractorAbstractionsController < ApplicationController
    include Abstractor::Methods::Controllers::AbstractorAbstractionsController
    include Abstractor::AbstractorAbstractionsControllerCustomMethods
    before_action :authenticate_user!
  end
end