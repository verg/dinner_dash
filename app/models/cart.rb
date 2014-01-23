class Cart < ActiveRecord::Base
  has_many :line_items, dependent: :destroy
  belongs_to :user

  def add_product(product_or_product_id, quantity=1)
    product_id = product_or_product_id.id if product_or_product_id.respond_to?(:id)
    line_items.create(product_id: product_id, quantity: quantity)
  end

  def find_or_create_line_item_by_product_id(product_id)
    line_items.find_or_create_by(product_id: product_id)
  end

  def total_price
    line_items.includes(:product).reduce(Money.new(0)) { |sum, item|
      sum + item.total_price
    }
  end

  def count
    line_items.pluck(:quantity).reduce(0, :+)
  end
end
