require 'uri'

class Product < ActiveRecord::Base
  validates :title, presence: true
  validates :title, uniqueness: true
  validates_inclusion_of :available, :in => [true, false]
  validates :price_cents, numericality: { greater_than_or_equal_to: 0,
                                          only_integer: true }

  has_many :category_products
  has_many :categories, through: :category_products
  has_many :line_items
  monetize :price_cents

  has_attached_file :photo, styles: { medium: "300x300", small: "150x150" }

  validates_attachment :photo,
    :content_type =>
      { :content_type => ["image/jpeg", "image/jpg", "image/gif", "image/png"] },
      :if => :photo_attached?

  def self.available
    where(available: true).order(:display_rank)
  end

  def self.retired
    where(available: false).order(:display_rank)
  end

  private

  def photo_attached?
    self.photo.file?
  end
end
