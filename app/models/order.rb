class Order < ApplicationRecord
  belongs_to :user
  belongs_to :shipping_address, class_name: 'Address', optional: true
  belongs_to :billing_address, class_name: 'Address', optional: true
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items

  validates :order_number, presence: true, uniqueness: true
  validates :subtotal, :tax_amount, :shipping_cost, :total_amount, presence: true,
            numericality: { greater_than_or_equal_to: 0 }
  validates :status, presence: true, inclusion: { in: %w[pending paid shipped delivered cancelled] }
  validates :gst_rate, :pst_rate, :hst_rate, presence: true,
            numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 1 }

  before_validation :generate_order_number, on: :create

  private

  def generate_order_number
    self.order_number = "WP#{Date.current.strftime('%Y%m%d')}#{SecureRandom.hex(4).upcase}"
  end
end