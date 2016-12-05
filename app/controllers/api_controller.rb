class ApiController < ActionController::Base
  protect_from_forgery with: :null_session
  before_action :http_basic_authenticate

  private
    def http_basic_authenticate
      authenticate_or_request_with_http_basic do |username, password|
        user = User.where(username: username, authentication_token: password).first
        user.present? && user.role_assignments.select { |role_assignment| role_assignment.role.name == Role::ROLE_CASEFINDER_API }.any?
      end
      warden.custom_failure! if performed?
    end
end

