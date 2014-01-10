class Item < ActiveRecord::Base
  validates :title, presence: true
  validates :title, uniqueness: true
  validates :price_cents, numericality: { greater_than_or_equal_to: 0,
                                          only_integer: true }
end
