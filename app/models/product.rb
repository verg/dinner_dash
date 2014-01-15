require 'uri'

class Product < ActiveRecord::Base
  validates :title, presence: true
  validates :title, uniqueness: true
  validate :photo_validator
  validates :price_cents, numericality: { greater_than_or_equal_to: 0,
                                          only_integer: true }

  has_many :category_products
  has_many :categories, through: :category_products
  has_many :line_items

  monetize :price_cents

  private

  def photo_validator
    return if photo.blank?  # early return if blank allows photo to be optional
    errors.add(:photo, "must be a valid URI") unless valid_url?(photo)
  end

  def valid_url?(url)
    begin
      uri = URI.parse(url)
      uri.kind_of?(URI::HTTP)
    rescue URI::InvalidURIError
      false
    end
  end
end
