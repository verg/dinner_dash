class AdminDashboard
  attr_reader :categories, :products, :orders

  def initialize(args={})
    @categories = Category.all
    @products = Product.available
    @orders = OrderSearch.new.search(args)
  end
end
