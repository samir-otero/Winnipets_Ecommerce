class Cart
  attr_reader :items

  def initialize(session_cart = {})
    @items = session_cart || {}
  end

  def add_item(product_id, quantity = 1)
    product_id = product_id.to_s
    if @items[product_id]
      @items[product_id] += quantity.to_i
    else
      @items[product_id] = quantity.to_i
    end
  end

  def remove_item(product_id)
    @items.delete(product_id.to_s)
  end

  def update_quantity(product_id, quantity)
    product_id = product_id.to_s
    quantity = quantity.to_i
    if quantity <= 0
      remove_item(product_id)
    else
      @items[product_id] = quantity
    end
  end

  def total_items
    @items.values.sum
  end

  def empty?
    @items.empty?
  end

  def clear
    @items.clear
  end

  def cart_items
    return [] if @items.empty?

    Product.includes(:images).where(id: @items.keys).map do |product|
      ::CartItem.new(product, @items[product.id.to_s])
    end
  end

  def subtotal
    cart_items.sum(&:total_price)
  end

  def total_with_tax(province = nil)
    return subtotal unless province

    tax_amount = subtotal * province.tax_rate
    subtotal + tax_amount
  end

  def tax_amount(province = nil)
    return 0 unless province

    subtotal * province.tax_rate
  end

  def gst_amount(province = nil)
    return 0 unless province

    subtotal * province.gst_rate
  end

  def pst_amount(province = nil)
    return 0 unless province

    subtotal * province.pst_rate
  end

  def hst_amount(province = nil)
    return 0 unless province

    subtotal * province.hst_rate
  end
end