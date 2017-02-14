module Abstractor
  module AbstractorAbstractionSchemasControllerCustomMethods
  end

  class AbstractorAbstractionSchemasController < ApplicationController
    include Abstractor::Methods::Controllers::AbstractorAbstractionSchemasController
    include Abstractor::AbstractorAbstractionSchemasControllerCustomMethods
    acts_as_token_authentication_handler_for User, only: [:show]
    protect_from_forgery except: [:show]
    before_action :authenticate_user!, only: :index
  end
end
