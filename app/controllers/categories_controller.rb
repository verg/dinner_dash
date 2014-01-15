class CategoriesController < ApplicationController
  def show
    @category = Category.find category_id
    @products = @category.products
  end

  private

  def category_id
    params[:id]
  end
end
