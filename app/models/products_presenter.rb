class ProductsPresenter
  def self.for(category_id, cart)
    new(category_id, cart)
  end

  attr_reader :categories, :products, :cart
  def initialize(category_id=nil, cart)
    @cart = cart
    if category_id
      @categories = Category.find category_id
      @products = @categories.products
    else
      @categories = Category.all
      @products = Product.available
    end
  end
end
