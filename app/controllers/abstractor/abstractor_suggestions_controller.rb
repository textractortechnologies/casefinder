module Abstractor
  module AbstractorSuggestionsControllerCustomMethods
  end

  class AbstractorSuggestionsController < ApplicationController
    include Abstractor::Methods::Controllers::AbstractorSuggestionsController
    include Abstractor::AbstractorSuggestionsControllerCustomMethods
    acts_as_token_authentication_handler_for User, only: [:create]
    protect_from_forgery except: [:create]
  end
end