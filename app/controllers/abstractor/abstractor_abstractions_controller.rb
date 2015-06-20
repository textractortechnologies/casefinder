module Abstractor
  module AbstractorAbstractionsControllerCustomMethods
  end

  class AbstractorAbstractionsController < ApplicationController
    include Abstractor::Methods::Controllers::AbstractorAbstractionsController
    include Abstractor::AbstractorAbstractionsControllerCustomMethods
    before_action :authenticate_user!
  end
end