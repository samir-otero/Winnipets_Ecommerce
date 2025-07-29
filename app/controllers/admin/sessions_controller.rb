class Admin::SessionsController < ApplicationController
  layout 'admin'

  def new
    # Login form
    redirect_to admin_dashboard_path if admin_logged_in?
  end

  def create
    admin_user = AdminUser.find_by(email: params[:email].downcase)

    if admin_user&.authenticate(params[:password])
      session[:admin_user_id] = admin_user.id
      flash[:notice] = "Welcome back, #{admin_user.first_name}!"
      redirect_to admin_dashboard_path
    else
      flash.now[:alert] = "Invalid email or password."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session[:admin_user_id] = nil
    flash[:notice] = "You have been logged out."
    redirect_to admin_login_path
  end
end