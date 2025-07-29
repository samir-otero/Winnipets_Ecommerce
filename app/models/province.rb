class Province < ApplicationRecord
  has_many :users, dependent: :destroy
  has_many :addresses, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :abbreviation, presence: true, uniqueness: true, length: { is: 2 }
  validates :gst_rate, :pst_rate, :hst_rate, presence: true,
            numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 1 }

  def tax_rate
    gst_rate + pst_rate + hst_rate
  end
end