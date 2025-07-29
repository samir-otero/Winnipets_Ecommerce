class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :unit_price, :total_price, presence: true, numericality: { greater_than: 0 }
  validates :product_name, :product_sku, presence: true

  before_validation :set_historical_data, on: :create
  before_validation :calculate_total_price

  private

  def set_historical_data
    if product.present?
      self.product_name = product.name
      self.product_sku = product.sku
      self.unit_price = product.current_price
    end
  end

  def calculate_total_price
    self.total_price = unit_price * quantity if unit_price.present? && quantity.present?
  end
end