class AdminDashboard
  attr_reader :categories, :products, :orders

  def initialize
    @categories = Category.all
    @products = Product.available
    @orders = Order.all
  end
end
