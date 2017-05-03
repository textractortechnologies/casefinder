module Abstractor
  module AbstractorObjectValuesControllerCustomMethods
  end

  class AbstractorObjectValuesController < ApplicationController
    include Abstractor::Methods::Controllers::AbstractorObjectValuesController
    include Abstractor::AbstractorObjectValuesControllerCustomMethods
    before_action :authenticate_user!, :authorize_user!

    def authorize_user!
      authorize Abstractor::AbstractorObjectValue.new, :all?
    end
  end
end
