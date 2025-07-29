class Product < ApplicationRecord
  belongs_to :category
  has_many :order_items, dependent: :destroy
  has_many :orders, through: :order_items
  has_many_attached :images

  validates :name, presence: true
  validates :description, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :sale_price, numericality: { greater_than: 0 }, allow_blank: true
  validates :stock_quantity, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :sku, presence: true, uniqueness: true
  validates :weight, numericality: { greater_than: 0 }, allow_blank: true
  validate :acceptable_images

  scope :active, -> { where(is_active: true) }
  scope :on_sale, -> { where.not(sale_price: nil) }

  def current_price
    sale_price.present? ? sale_price : price
  end

  def on_sale?
    sale_price.present? && sale_price < price
  end

  private

  def acceptable_images
    return unless images.attached?

    images.each do |image|
      unless image.blob.byte_size <= 5.megabytes
        errors.add(:images, "Images must be less than 5MB")
      end

      unless image.blob.content_type.starts_with?('image/')
        errors.add(:images, "Must be an image file")
      end
    end
  end
end