class ProductsController < ApplicationController

  before_filter :authenticate_admin!, except: [:index, :show]

  def index
    @presenter = ProductsPresenter.new(current_cart)
  end

  def new
    @product = Product.new
    @categories = Category.all
  end

  def show
    @product = Product.find(product_id)
  end

  def create
    @product = Product.new(product_params)
    @categories = Category.all
    @product.categories << @categories.where(id: category_ids)

    if @product.save
      redirect_to dashboard_path
    else
      render :new
    end
  end

  def edit
    @product = Product.find(product_id)
  end

  def update
    @product = Product.find(product_id)

    if @product.update(product_params)
      @product.categories = Category.where(id: category_ids)
      redirect_to dashboard_path
    else
      render :edit
    end
  end

  def retired
    @products = Product.retired
  end

  private

  def product_id
    params[:id]
  end

  def product_params
    params.require(:product).
      permit(:title, :price, :description, :display_rank, :photo, :available)
  end

  def category_ids
    params[:product][:category_ids]
  end
end
