module Abstractor
  module AbstractorRulesControllerCustomMethods
  end

  class AbstractorRulesController < ApplicationController
    include Abstractor::Methods::Controllers::AbstractorRulesController
    include Abstractor::AbstractorRulesControllerCustomMethods
    before_action :authenticate_user!, :authorize_user!

	def authorize_user!
      authorize Abstractor::AbstractorRule.new, :all?
    end
  end
end