class BatchImportPolicy < ApplicationPolicy
  def new?
    false # user.role?
  end

  def create?
    false # user.role?
  end
end