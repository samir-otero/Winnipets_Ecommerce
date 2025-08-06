class CartController < ApplicationController
  before_action :set_product, only: [:add_item]

  def show
    @cart_items = current_cart.cart_items
    @subtotal = current_cart.subtotal
  end

  def add_item
    quantity = params[:quantity].present? ? params[:quantity].to_i : 1
    current_cart.add_item(@product.id, quantity)
    session[:cart] = current_cart.items

    respond_to do |format|
      format.html { redirect_to cart_path, notice: "#{@product.name} added to cart!" }
      format.json { render json: {
        success: true,
        message: "#{@product.name} added to cart!",
        cart_count: cart_item_count
      }}
    end
  end

  def remove_item
    product_id = params[:id]
    product_name = Product.find(product_id).name rescue "Item"

    current_cart.remove_item(product_id)
    session[:cart] = current_cart.items

    redirect_to cart_path, notice: "#{product_name} removed from cart."
  end

  def update_quantity
    product_id = params[:id]
    quantity = params[:quantity].to_i

    current_cart.update_quantity(product_id, quantity)
    session[:cart] = current_cart.items

    respond_to do |format|
      format.html { redirect_to cart_path }
      format.json {
        render json: {
          success: true,
          subtotal: helpers.number_to_currency(current_cart.subtotal),
          cart_count: cart_item_count,
          item_total: helpers.number_to_currency(current_cart.cart_items.find { |item| item.id == product_id.to_i }&.total_price || 0)
        }
      }
    end
  end

  def clear
    current_cart.clear
    session[:cart] = {}
    redirect_to cart_path, notice: "Cart cleared!"
  end

  private

  def set_product
    @product = Product.active.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to products_path, alert: "Product not found."
  end
end