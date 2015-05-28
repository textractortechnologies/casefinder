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
      @about = params[:about_type].constantize.find(params[:about_id])
      Abstractor::AbstractorAbstraction.update_abstractor_abstraction_other_value(@about.abstractor_abstractions, abstractor_abstraction_value)
      respond_to do |format|
        format.html { redirect_to main_app.next_pathology_case_pathology_cases_path }
      end
    end
  end

  class AbstractorAbstractionsController < ApplicationController
    include Abstractor::Methods::Controllers::AbstractorAbstractionsController
    include Abstractor::AbstractorAbstractionsControllerCustomMethods
    before_action :authenticate_user!
  end
end