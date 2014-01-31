class AdminDashboard
  attr_reader :categories, :products

  def initialize
    @categories = Category.all
    @products = Product.all
  end
end
