class DashboardController < ApplicationController
  before_filter :authenticate_admin!

  def index
    @dashboard = AdminDashboard.new
  end
end
