module Abstractor
  class Abstractor::AbstractorAbstractionGroupPolicy < ApplicationPolicy
    def all?
      user.role?
    end
  end
end