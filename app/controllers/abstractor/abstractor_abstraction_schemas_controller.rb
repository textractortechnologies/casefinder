module Abstractor
  module AbstractorAbstractionSchemasControllerCustomMethods
    def show
      super
    end
  end

  class AbstractorAbstractionSchemasController < ApplicationController
    include Abstractor::Methods::Controllers::AbstractorAbstractionSchemasController
    include Abstractor::AbstractorAbstractionSchemasControllerCustomMethods
    # acts_as_token_authentication_handler_for User, only: [:show]
  end
end
