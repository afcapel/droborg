class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  layout -> { params[:modal].present? ? 'modal' : 'application' }

  private

  def current_user
    @current_user ||= User.where(id: session[:user_id]).first if session[:user_id]
  end
  helper_method :current_user

  def authorize
    redirect_to login_url, alert: "Not authorized" if current_user.nil?
  end
end
