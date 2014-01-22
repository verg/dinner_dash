class Cart < ActiveRecord::Base
  has_many :line_items
  belongs_to :user

  def add_product(product_id, quantity=1)
    line_items.create(product: product_id, quantity: quantity)
  end

  def find_or_create_line_item_by_product_id(product_id)
    line_items.find_or_create_by(product_id: product_id)
  end
end
