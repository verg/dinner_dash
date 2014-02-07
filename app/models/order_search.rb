class OrderSearch

  def search(args)
    orders_page = args.fetch(:orders_page) { 1 }
    orders_per_page = args.fetch(:orders_per_page) { 30 }
    order_by = args.fetch(:order_by_query) { "created_at DESC" }

    search_by_user_query = args.fetch(:search_by_user_query) { nil }
    order_status = args.fetch(:order_status) { nil }

    Order.where(query_conditions(search_by_user_query, order_status)).
      order(order_by).paginate(page: orders_page, per_page: orders_per_page)
  end

  private

  def query_conditions(search_term, status)
    args = {}
    args = args.merge(user_id_args_for(search_term)) if search_term
    args = args.merge(status_query_args(status)) if status
    args
  end

  def user_id_args_for(search_term)
    { user_id:  User.basic_search(search_term).map(&:id) }
  end

  def status_query_args(status)
    Order.status_query_args(status)
  end
end
