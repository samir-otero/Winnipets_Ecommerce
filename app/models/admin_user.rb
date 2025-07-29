class AdminUser < ApplicationRecord
  has_secure_password

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :first_name, :last_name, presence: true
  validates :role, presence: true, inclusion: { in: %w[admin manager staff] }
  validates :password, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }
end