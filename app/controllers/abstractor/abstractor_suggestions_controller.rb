module Abstractor
  module AbstractorSuggestionsControllerCustomMethods
  end

  class AbstractorSuggestionsController < ApplicationController
    include Abstractor::Methods::Controllers::AbstractorSuggestionsController
    include Abstractor::AbstractorSuggestionsControllerCustomMethods
    acts_as_token_authentication_handler_for User, only: [:create]
    protect_from_forgery except: [:create]
    before_action :authenticate_user!, :authorize_user!, except: :create

    def authorize_user!
      authorize Abstractor::AbstractorSuggestion.new, :all?
    end
  end
end