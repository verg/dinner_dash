class CategoriesController < ApplicationController
  def show
    @presenter = ProductsPresenter.for(category_id, current_cart)
  end

  private

  def category_id
    params[:id]
  end
end
