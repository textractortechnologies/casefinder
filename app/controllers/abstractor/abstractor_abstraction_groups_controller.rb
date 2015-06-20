module Abstractor
  module AbstractorAbstractionGroupsControllerCustomMethods
  end

  class AbstractorAbstractionGroupsController < ApplicationController
    include Abstractor::Methods::Controllers::AbstractorAbstractionGroupsController
    include Abstractor::AbstractorAbstractionGroupsControllerCustomMethods
    before_action :authenticate_user!
  end
end
