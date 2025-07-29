class ApplicationController < ActionController::Base
  private

  def admin_logged_in?
    !!current_admin_user
  end

  def current_admin_user
    @current_admin_user ||= AdminUser.find(session[:admin_user_id]) if session[:admin_user_id]
  rescue ActiveRecord::RecordNotFound
    session[:admin_user_id] = nil
    nil
  end

  helper_method :current_admin_user, :admin_logged_in?
end