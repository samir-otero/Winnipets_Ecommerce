class Page < ApplicationRecord
  validates :title, :content, :slug, presence: true
  validates :slug, uniqueness: true

  before_validation :generate_slug, on: :create

  private

  def generate_slug
    self.slug = title.parameterize if title.present?
  end
end