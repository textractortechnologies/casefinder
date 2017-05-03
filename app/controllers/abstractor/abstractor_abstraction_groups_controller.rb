module Abstractor
  module AbstractorAbstractionGroupsControllerCustomMethods
  end

  class AbstractorAbstractionGroupsController < ApplicationController
    include Abstractor::Methods::Controllers::AbstractorAbstractionGroupsController
    include Abstractor::AbstractorAbstractionGroupsControllerCustomMethods
    before_action :authenticate_user!, :authorize_user!

    def authorize_user!
      authorize Abstractor::AbstractorAbstractionGroup.new, :all?
    end
  end
end
