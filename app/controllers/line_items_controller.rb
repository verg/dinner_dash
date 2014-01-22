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

  def destroy
    LineItem.find(line_item_id).destroy
    redirect_to cart_path
  end

  private

  def product_id
    params[:product_id]
  end

  def line_item_id
    params[:id]
  end
end
