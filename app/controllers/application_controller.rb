class ApplicationController < ActionController::Base
  include Pundit::Authorization
  include Passwordless::ControllerHelpers

  helper_method :current_user, :current_session

  private
  def current_user
    return unless name = current_session&.name
    User.find(attribute: 'uid', value: name)
  end

  def current_session
    @current_session ||= authenticate_by_session(Auth)
  end

  def require_session!
    return if current_session
    redirect_to auth.sign_in_path
  end
end
