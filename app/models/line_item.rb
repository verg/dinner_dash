class LineItem < ActiveRecord::Base
  belongs_to :cart
  belongs_to :product

  def increment_quantity(by=1)
    original_qty = "CASE WHEN quantity IS NULL THEN 0 ELSE quantity END"
    self.class.update_all("quantity = quantity + #{by.to_i}", "id = #{id}")
    reload
  end
end
