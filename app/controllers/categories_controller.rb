class CategoriesController < ApplicationController
  def show
    @presenter = ProductsPresenter.for(category_id, current_cart)
    # @category = Category.find category_id
    # @products = @category.products
  end

  private

  def category_id
    params[:id]
  end
end
