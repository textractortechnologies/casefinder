module Abstractor
  class Abstractor::AbstractorAbstractionPolicy < ApplicationPolicy
    def all?
      user.role?
    end
  end
end