class ApplicationController < ActionController::Base
  before_action :initialize_cart

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

  # Cart functionality
  def initialize_cart
    session[:cart] ||= {}
  end

  def current_cart
    @current_cart ||= Cart.new(session[:cart])
  end

  def cart_item_count
    current_cart.total_items
  end

  helper_method :current_admin_user, :admin_logged_in?, :current_cart, :cart_item_count
end