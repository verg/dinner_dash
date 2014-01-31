class AdminDashboard
  attr_reader :categories

  def initialize
    @categories = Category.all
  end
end
