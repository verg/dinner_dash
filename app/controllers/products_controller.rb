class ProductsController < ApplicationController
  def index
    @presenter = ProductsPresenter.new(current_cart)
  end

  def new
    @product = Product.new
  end
end
