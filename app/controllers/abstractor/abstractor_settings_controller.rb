module Abstractor
  module AbstractorSettingsControllerCustomMethods
  end

  class AbstractorSettingsController < ApplicationController
    include Abstractor::Methods::Controllers::AbstractorSettingsController
    include Abstractor::AbstractorSettingsControllerCustomMethods
    before_action :authenticate_user!, :authorize_user!

	def authorize_user!
      authorize Abstractor::AbstractorRule.new, :all?
      authorize Abstractor::AbstractorAbstractionSchema.new, :all?
    end
  end
end