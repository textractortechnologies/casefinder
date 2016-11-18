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

  def allowed_actions
    [self.class.login_success, self.class.login_failure, self.class.unauthorized_access_attempt]
  end
end
