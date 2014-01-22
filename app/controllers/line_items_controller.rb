class LineItemsController < ApplicationController

  def create
    line_item = current_cart.find_or_create_line_item_by_product_id(product_id)
    line_item.increment_quantity

    begin
      redirect_to :back
    rescue RedirectBackError
      redirect_to :root
    end
  end

  private

  def product_id
    params[:product_id]
  end
end
