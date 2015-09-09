class BatchExportPolicy < ApplicationPolicy
  def new?
    user.role?
  end

  def create?
    user.role?
  end

  def show?
    user.role?
  end
end