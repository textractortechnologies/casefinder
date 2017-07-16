module Abstractor
  class Abstractor::AbstractorRulePolicy < ApplicationPolicy
    def all?
      user.role? && user.has_role?(Role::ROLE_CASEFINDER_ADMIN)
    end
  end
end