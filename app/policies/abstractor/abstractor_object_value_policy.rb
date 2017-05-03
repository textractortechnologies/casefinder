module Abstractor
  class Abstractor::AbstractorObjectValuePolicy < ApplicationPolicy
    def all?
      user.role? && user.has_role?(Role::ROLE_CASEFINDER_ADMIN)
    end
  end
end