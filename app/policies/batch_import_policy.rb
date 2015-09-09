class BatchImportPolicy < ApplicationPolicy
  def new?
    user.role?
  end

  def create?
    user.role?
  end
end