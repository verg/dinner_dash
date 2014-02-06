class OrderSearch
  def self.by_user_attributes search_term
    users = User.includes(:orders).basic_search(search_term).references(:orders)
    users.reduce([]) { |orders, user| orders + user.orders }
  end
end
