class Users::SessionsController < Devise::SessionsController
  after_filter :log_failed_login, only: :new

  def create
    super
    username_param = params[:user][:username] if params[:user].present?  
    AccessAudit.create!(username: username_param, action: AccessAudit.login_success)
  end

  private
  def log_failed_login
    username_param = params[:user][:username] if params[:user].present?  
    AccessAudit.create!(username: username_param, action: AccessAudit.login_failure) if failed_login?
  end 

  def failed_login?
    (options = env['warden.options']) && options[:action] == 'unauthenticated'
  end 
end
