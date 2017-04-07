module Abstractor
  module AbstractorRulesControllerCustomMethods
  end

  class AbstractorRulesController < ApplicationController
    include Abstractor::Methods::Controllers::AbstractorRulesController
    include Abstractor::AbstractorRulesControllerCustomMethods
    acts_as_token_authentication_handler_for User, only: [:index]
    protect_from_forgery except: [:index]
  end
end