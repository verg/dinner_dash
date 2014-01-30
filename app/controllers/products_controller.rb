class ProductsController < ApplicationController
  before_filter :authenticate_admin!, except: [:index]
  def index
    @presenter = ProductsPresenter.new(current_cart)
  end

  def new
    @product = Product.new
    @categories = Category.all
  end

  def create
    product = Product.new(product_params)
    product.categories << Category.where(id: category_ids)

    if product.save
      redirect_to dashboard_path
    else
      render :new
    end
  end

  private

  def product_params
    params.require(:product).
      permit(:title, :price, :description, :display_rank, :photo)
  end

  def category_ids
    params[:category_ids]
  end
end
