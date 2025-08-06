class CartItem
  attr_reader :product, :quantity

  def initialize(product, quantity)
    @product = product
    @quantity = quantity.to_i
  end

  def total_price
    @product.current_price * @quantity
  end

  def unit_price
    @product.current_price
  end

  def name
    @product.name
  end

  def sku
    @product.sku
  end

  def id
    @product.id
  end

  def image
    @product.images.attached? ? @product.images.first : nil
  end
end