class CategoriesController < ApplicationController
  before_filter :authenticate_admin!, except: [:show]

  def show
    @presenter = ProductsPresenter.for(category_id, current_cart)
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    @category.products << Product.where(id: product_ids)

    if @category.save
      redirect_to dashboard_path
    else
      render :new
    end
  end

  def edit
    @category = Category.find(category_id)
  end

  def update
    @category = Category.find(category_id)

    if @category.update(category_params)
      @category.products = Product.where(id: product_ids)
      redirect_to dashboard_path
    else
      render :edit
    end
  end

  private

  def category_id
    params[:id]
  end

  def category_params
    params.require(:category).permit(:name)
  end

  def product_ids
    params[:category][:product_ids]
  end
end
