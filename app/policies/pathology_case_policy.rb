class PathologyCasePolicy < ApplicationPolicy
  def index?
    user.role?
  end

  def edit?
    user.role?
  end

  def upload?
    user.role?
  end

  def import?
    user.role?
  end

  def next_pathology_case?
    user.role?
  end

  def last_pathology_case?
    user.role?
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      if user.role?
        PathologyCase
      else
        PathologyCase.none
      end
    end
  end
end