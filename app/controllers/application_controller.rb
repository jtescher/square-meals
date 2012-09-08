class ApplicationController < ActionController::Base
  protect_from_forgery

private

  def current_user
    cookies[:auth_token]
  end
  helper_method :current_user

end
