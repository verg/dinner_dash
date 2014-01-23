class ProductsController < ApplicationController
  def index
    @presenter = ProductsPresenter.new(current_cart)
  end
end
