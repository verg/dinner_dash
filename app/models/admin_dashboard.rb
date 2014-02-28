class AdminDashboard
  attr_reader :categories, :products, :orders, :orders_filtered_by

  def initialize(args={})
    @categories = Category.all
    @products = Product.available
    @orders = OrderSearch.new.search(args)
    filtered_by = args.fetch(:order_status) { :none }
    @orders_filtered_by = filtered_by.to_sym
  end

  def has_order_filter?
    @orders_filtered_by != :none
  end
end
