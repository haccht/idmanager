class ApplicationController < ActionController::Base
  include Pundit::Authorization
  include Passwordless::ControllerHelpers
  helper_method :current_user, :current_session

  private
  def current_user
    current_session&.user
  end

  def current_session
    @current_session ||= authenticate_by_session(Session)
  end

  def require_session!
    return if current_session
    redirect_to sessions.sign_in_path, flash: { error: 'Sign in required!' }
  end
end
