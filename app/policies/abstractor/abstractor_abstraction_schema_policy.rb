module Abstractor
  class Abstractor::AbstractorAbstractionSchemaPolicy < ApplicationPolicy
    def all?
      user.role? && user.has_role?(Role::ROLE_CASEFINDER_ADMIN)
    end
  end
end