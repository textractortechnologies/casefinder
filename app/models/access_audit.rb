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

  def self.controller_action_access
    'controller action access'
  end

  def self.allowed_actions
    [ self.login_success, 
      self.login_failure, 
      self.unauthorized_access_attempt, 
      self.controller_action_access
    ]
  end

  def allowed_actions
    self.class.allowed_actions
  end
end
