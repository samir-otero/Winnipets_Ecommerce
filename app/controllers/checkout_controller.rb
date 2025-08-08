class CheckoutController < ApplicationController
  before_action :check_cart_not_empty
  before_action :set_provinces, only: [:new, :create, :confirmation]

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
    if address_params[:province_id].present?
      @address.province = Province.find(address_params[:province_id])
    end

    if @guest_user.valid? && @address.valid?
      # Store checkout data in session for confirmation
      session[:checkout_user] = {
        first_name: guest_user_params['first_name'],
        last_name: guest_user_params['last_name'],
        email: guest_user_params['email'],
        phone: guest_user_params['phone']
      }
      session[:checkout_address] = address_params.to_h

      redirect_to checkout_confirmation_path, notice: "Please review your order details below."
    else
      flash.now[:alert] = "Please correct the errors below."
      render :new
    end
  end

  def confirmation
    # Retrieve checkout data from session
    @user_data = session[:checkout_user]
    @address_data = session[:checkout_address]

    # Redirect back to checkout if session data is missing
    unless @user_data && @address_data
      redirect_to new_checkout_path, alert: "Please complete the checkout form."
      return
    end

    @province = Province.find(@address_data['province_id'])

    # Cart and pricing calculations
    @cart_items = current_cart.cart_items
    @subtotal = current_cart.subtotal
    @gst_amount = current_cart.gst_amount(@province)
    @pst_amount = current_cart.pst_amount(@province)
    @hst_amount = current_cart.hst_amount(@province)
    @tax_amount = @gst_amount + @pst_amount + @hst_amount
    @shipping_cost = calculate_shipping_cost(@province, @subtotal) # Fixed shipping calculation
    @total_amount = @subtotal + @tax_amount + @shipping_cost

    # Create temporary objects for display
    @guest_user = GuestUser.new(@user_data)
    @address = Address.new(@address_data)
    @address.province = @province
  end

  def process_order
    # Retrieve checkout data from session
    user_data = session[:checkout_user]
    address_data = session[:checkout_address]

    unless user_data && address_data
      redirect_to new_checkout_path, alert: "Checkout session expired. Please start over."
      return
    end

    province = Province.find(address_data['province_id'])

    # Validate stock availability before creating the order
    unless validate_stock_availability
      return # Stop processing if validation failed
    end

    begin
      # Create the order using the original logic
      @order = create_order_from_session(user_data, address_data, province)

      if @order && @order.persisted?
        # Update product stock quantities
        update_product_stock(@order)

        # Clear the checkout session data
        session.delete(:checkout_user)
        session.delete(:checkout_address)

        # Clear the cart
        current_cart.clear
        session[:cart] = {}

        redirect_to order_confirmation_path(@order), notice: "Order placed successfully!"
      else
        error_messages = @order&.errors&.full_messages&.join(', ') || "Unknown error"
        flash[:alert] = "There was an error processing your order: #{error_messages}"
        redirect_to checkout_confirmation_path
      end

    rescue => e
      Rails.logger.error "Order processing error: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      flash[:alert] = "There was an error processing your order: #{e.message}"
      redirect_to checkout_confirmation_path
    end
  end

  def order_confirmation
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

  def validate_stock_availability
    current_cart.cart_items.each do |cart_item|
      product = cart_item.product
      if product.stock_quantity < cart_item.quantity
        flash[:alert] = "#{product.name} has insufficient stock. Only #{product.stock_quantity} available."
        redirect_to cart_path
        return false
      end
    end
    true
  end

  def calculate_shipping_cost(province, subtotal)
    # Add your shipping logic here
    # For now, returning 0 for free shipping
    # You might want to add logic like:
    # return 0 if subtotal > 100  # Free shipping over $100
    # return province.shipping_rate || 10  # Default shipping rate
    0
  end

  def update_product_stock(order)
    order.order_items.each do |order_item|
      product = order_item.product
      new_stock = product.stock_quantity - order_item.quantity
      product.update!(stock_quantity: [new_stock, 0].max) # Ensure stock doesn't go negative
    end
  end

  def create_order_from_session(user_data, address_data, province)
    ActiveRecord::Base.transaction do
      # Create or find user
      user = find_or_create_user(user_data, province)

      # Create address
      address = create_address(user, address_data, province)

      # Calculate totals
      subtotal = current_cart.subtotal
      tax_amount = current_cart.tax_amount(province)
      shipping_cost = calculate_shipping_cost(province, subtotal)
      total_amount = subtotal + tax_amount + shipping_cost

      # Create order
      order = user.orders.create!(
        subtotal: subtotal,
        tax_amount: tax_amount,
        shipping_cost: shipping_cost,
        total_amount: total_amount,
        status: 'pending',
        shipping_address: address,
        billing_address: address,
        gst_rate: province.gst_rate,
        pst_rate: province.pst_rate,
        hst_rate: province.hst_rate
      )

      # Create order items
      create_order_items(order)

      order
    end
  end

  def find_or_create_user(user_data, province)
    existing_user = User.find_by(email: user_data['email'])

    if existing_user
      # Update existing user info if needed
      existing_user.update!(
        first_name: user_data['first_name'],
        last_name: user_data['last_name'],
        phone: user_data['phone']
      )
      existing_user
    else
      User.create!(
        first_name: user_data['first_name'],
        last_name: user_data['last_name'],
        email: user_data['email'],
        phone: user_data['phone'],
        province: province,
        password: SecureRandom.hex(10),
        user_type: 'guest'
      )
    end
  end

  def create_address(user, address_data, province)
    user.addresses.create!(
      address_line_1: address_data['address_line_1'],
      address_line_2: address_data['address_line_2'],
      city: address_data['city'],
      postal_code: address_data['postal_code'],
      province: province,
      address_type: 'both'
    )
  end

  def create_order_items(order)
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
  end
end