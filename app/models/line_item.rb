class LineItem < ActiveRecord::Base
  belongs_to :cart
  belongs_to :product
  belongs_to :user
  belongs_to :order
  validates :quantity, numericality: { greater_than_or_equal_to: 0 }

  def increment_quantity(by=1)
    original_qty = "CASE WHEN quantity IS NULL THEN 0 ELSE quantity END"
    self.class.where(id: id).update_all("quantity = #{original_qty} + #{by.to_i}")
    reload
  end

  def product_title
    product.title
  end

  def product_description
    product.description
  end

  def small_product_photo
    product.small_photo
  end

  def total_price
    product.price * quantity
  end
end
