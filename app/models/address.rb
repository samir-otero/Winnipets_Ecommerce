class Address < ApplicationRecord
  belongs_to :user
  belongs_to :province
  has_many :orders_as_shipping, class_name: 'Order', foreign_key: 'shipping_address_id'
  has_many :orders_as_billing, class_name: 'Order', foreign_key: 'billing_address_id'

  validates :address_line_1, :city, :postal_code, presence: true
  validates :address_type, presence: true, inclusion: { in: %w[billing shipping both] }
  validates :postal_code, format: { with: /\A[A-Za-z]\d[A-Za-z] ?\d[A-Za-z]\d\z/, message: "must be valid Canadian postal code" }

  def full_address
    "#{address_line_1}, #{address_line_2}, #{city}, #{province.abbreviation} #{postal_code}".gsub(', ,', ',')
  end
end