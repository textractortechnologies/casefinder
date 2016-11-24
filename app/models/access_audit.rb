class AccessAudit < ActiveRecord::Base
  validates_presence_of :action
  validates_inclusion_of :action, in: :allowed_actions

  def self.login_success
    'login success'
  end

  def self.login_failure
    'login failure'
  end

  def self.unauthorized_access_attempt
    'unauthorized access attempt'
  end

  def self.allowed_actions
    [self.login_success, self.login_failure, self.unauthorized_access_attempt]
  end

  def allowed_actions
    self.class.allowed_actions
  end
end
