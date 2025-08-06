class CheckoutController < ApplicationController
  before_action :check_cart_not_empty
  before_action :set_provinces, only: [:new, :create]

  def new
    @guest_user = GuestUser.new
    @address = Address.new
    @cart_items = current_cart.cart_items
    @subtotal = current_cart.subtotal
  end

  def create
    @guest_user = GuestUser.new(guest_user_params)
    @address = Address.new(address_params)
    @cart_items = current_cart.cart_items
    @subtotal = current_cart.subtotal

    # Set province for address for validation
    @address.province = Province.find(address_params[:province_id]) if address_params[:province_id].present?

    if @guest_user.valid? && @address.valid?
      # Create the order
      @order = create_order

      if @order.persisted?
        # Clear the cart
        current_cart.clear
        session[:cart] = {}

        redirect_to order_confirmation_path(@order), notice: "Order placed successfully!"
      else
        flash.now[:alert] = "There was an error processing your order. Please try again."
        render :new
      end
    else
      flash.now[:alert] = "Please correct the errors below."
      render :new
    end
  end

  def confirmation
    @order = Order.find_by(id: params[:id])
    redirect_to root_path, alert: "Order not found." unless @order
  end

  private

  def check_cart_not_empty
    if current_cart.empty?
      redirect_to cart_path, alert: "Your cart is empty!"
    end
  end

  def set_provinces
    @provinces = Province.all.order(:name)
  end

  def guest_user_params
    params.require(:guest_user).permit(:first_name, :last_name, :email, :phone)
  end

  def address_params
    params.require(:address).permit(:address_line_1, :address_line_2, :city, :postal_code, :province_id)
  end

  def create_order
    province = Province.find(address_params[:province_id])

    # Create a temporary user for guest checkout
    user = User.create!(
      first_name: @guest_user.first_name,
      last_name: @guest_user.last_name,
      email: @guest_user.email,
      phone: @guest_user.phone,
      province: province,
      password: SecureRandom.hex(10) # Random password for guest users
    )

    # Create address
    address = user.addresses.create!(
      address_line_1: @address.address_line_1,
      address_line_2: @address.address_line_2,
      city: @address.city,
      postal_code: @address.postal_code,
      province: province,
      address_type: 'both'
    )

    # Calculate totals
    subtotal = current_cart.subtotal
    tax_amount = current_cart.tax_amount(province)
    total_amount = subtotal + tax_amount

    # Create order
    order = user.orders.create!(
      subtotal: subtotal,
      tax_amount: tax_amount,
      shipping_cost: 0, # You can add shipping logic later
      total_amount: total_amount,
      status: 'pending',
      shipping_address: address,
      billing_address: address,
      gst_rate: province.gst_rate,
      pst_rate: province.pst_rate,
      hst_rate: province.hst_rate
    )

    # Create order items
    current_cart.cart_items.each do |cart_item|
      order.order_items.create!(
        product: cart_item.product,
        quantity: cart_item.quantity,
        unit_price: cart_item.unit_price,
        total_price: cart_item.total_price,
        product_name: cart_item.name,
        product_sku: cart_item.sku
      )
    end

    order
  end
end