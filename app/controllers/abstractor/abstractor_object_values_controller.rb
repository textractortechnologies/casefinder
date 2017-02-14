module Abstractor
  class AbstractorObjectValuesController < Abstractor::ApplicationController
    include Abstractor::Methods::Controllers::AbstractorObjectValuesController
  end
end

module Abstractor
  module AbstractorObjectValuesControllerCustomMethods
  end

  class AbstractorObjectValuesController < ApplicationController
    include Abstractor::Methods::Controllers::AbstractorObjectValuesController
    include Abstractor::AbstractorObjectValuesControllerCustomMethods
    before_action :authenticate_user!
  end
end