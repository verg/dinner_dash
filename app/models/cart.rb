class Cart < ActiveRecord::Base
  has_many :line_items
  belongs_to :user

  def add_product(product_id, quantity=1)
    line_items.create(product: product_id, quantity: quantity)
  end
end
