module Abstractor
  class Abstractor::AbstractorSuggestionPolicy < ApplicationPolicy
    def all?
      user.role?
    end
  end
end