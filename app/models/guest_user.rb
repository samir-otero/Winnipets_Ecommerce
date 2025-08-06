class GuestUser
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveModel::Validations

  attribute :first_name, :string
  attribute :last_name, :string
  attribute :email, :string
  attribute :phone, :string

  validates :first_name, :last_name, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :phone, presence: true, format: {
    with: /\A[\+]?[1-9][\d]{0,15}\z/,
    message: "must be a valid phone number"
  }
end