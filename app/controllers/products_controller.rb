class ProductsController < ApplicationController
  def index
    @presenter = ProductsPresenter.new(current_cart)
    # @categories = Category.all
    # @products = Product.all
    # @cart = current_cart
  end
end
