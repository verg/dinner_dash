class AdminDashboard
  attr_reader :categories, :products, :orders

  def initialize(args={})
    @categories = Category.all
    @products = Product.available
    @orders_page = args.fetch(:orders_page) { 1 }
    @orders = Order.paginate(page: @orders_page, per_page: 30)
  end
end
