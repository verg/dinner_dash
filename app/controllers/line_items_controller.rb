class LineItemsController < ApplicationController
  def create
    current_cart.increment_quantity_or_create_line_item_by_product_id(product_id,
                                                                      quantity_param)
    begin
      redirect_to :back
    rescue RedirectBackError
      redirect_to :root
    end
  end

  def update
    line_item = LineItem.find(line_item_id)
    line_item.update_attributes(quantity: line_item_quantity)
    redirect_to cart_path
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

  def quantity_param
    params[:line_item][:quantity]
    # params[:quantity]
  end

  def line_item_quantity
    params[:line_item][:quantity]
  end
end
