class User < ApplicationRecord
  has_secure_password

  belongs_to :province
  has_many :addresses, dependent: :destroy
  has_many :orders, dependent: :destroy

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :first_name, :last_name, presence: true
  validates :phone, presence: true
  validates :password, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }
end