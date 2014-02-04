class AdminDashboard
  attr_reader :categories, :products, :orders

  def initialize(args={})
    @categories = Category.all
    @products = Product.available
    @orders_page = args.fetch(:orders_page) { 1 }
    @order_status = args.fetch(:order_status) { nil }
    @orders_per_page = args.fetch(:orders_per_page) { 30 }
    @orders = order_query
  end

  private

  def order_query
    if @order_status
      Order.query_by_status(@order_status).paginate(pagination_params)
    else
      Order.paginate(pagination_params)
    end
  end

  def pagination_params
    { page: @orders_page, per_page: @orders_per_page }
  end
end
