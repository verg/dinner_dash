require 'uri'

class Product < ActiveRecord::Base
  validates :title, presence: true
  validates :title, uniqueness: true
  validates :price_cents, numericality: { greater_than_or_equal_to: 0,
                                          only_integer: true }

  has_many :category_products
  has_many :categories, through: :category_products
  has_many :line_items

  has_attached_file :photo, styles: { medium: "300x300" }, default_url: "/images/:style/missing.png"
  validates_attachment :photo,
    :content_type => { :content_type => ["image/jpg", "image/gif", "image/png"] }
  monetize :price_cents

  def self.available
    all.order(:display_rank)
  end
end
