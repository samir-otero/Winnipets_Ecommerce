class Admin::DashboardController < Admin::ApplicationController
  def index
    @total_products = Product.count
    @active_products = Product.active.count
    @total_categories = Category.count
    @total_orders = Order.count
    @pending_orders = Order.where(status: 'pending').count
    @recent_orders = Order.includes(:user, :order_items).order(created_at: :desc).limit(5)
  end
end