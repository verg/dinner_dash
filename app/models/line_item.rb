class LineItem < ActiveRecord::Base
  belongs_to :cart
  belongs_to :product

  def increment_quantity(by=1)
    original_qty = "CASE WHEN quantity IS NULL THEN 0 ELSE quantity END"
    self.class.where(id: id).update_all("quantity = #{original_qty} + #{by.to_i}")
    reload
  end

  def product_title
    product.title
  end

  def total_price
    product.price * quantity
  end
end
