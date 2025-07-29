class Admin::ApplicationController < ApplicationController
  before_action :require_admin_login
  layout 'admin'

  private

  def require_admin_login
    unless admin_logged_in?
      flash[:alert] = "Please log in to access the admin area."
      redirect_to admin_login_path
    end
  end
end