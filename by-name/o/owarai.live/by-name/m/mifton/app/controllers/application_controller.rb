class ApplicationController < ActionController::Base

  helper_method :current_user
  helper_method :login?

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def login?
    !current_user.nil?
  end

end
