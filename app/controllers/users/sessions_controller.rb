class Users::SessionsController < Devise::SessionsController
  include WithAccessAudit

  before_action :audit_activity
  after_action  :log_failed_login, only: :new

  def create
    super
    username_param = params[:user][:username] if params[:user].present?  
    audit_activity(username: username_param, action: AccessAudit.login_success, skip_description: true)
  end

  private
    def log_failed_login
      username_param = params[:user][:username] if params[:user].present?  
      audit_activity(username: username_param, action: AccessAudit.login_failure, skip_description: true) if failed_login?
    end 

    def failed_login?
      (options = env['warden.options']) && options[:action] == 'unauthenticated'
    end 
end
