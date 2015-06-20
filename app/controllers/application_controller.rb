class ApplicationController < ActionController::Base
  def abstractor_user
    current_user.email if defined?(current_user)
  end
  helper_method :abstractor_user
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def back
    session[:history] || pathology_cases_url
  end

  def user_for_paper_trail
    current_user ? current_user.email : 'unknown'
  end

  protected
    def record_history
      session[:history] ||= nil
      session[:history] = request.url
    end
end
