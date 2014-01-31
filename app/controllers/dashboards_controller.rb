class DashboardsController < ApplicationController
  before_filter :authenticate_admin!

  def show
    @dashboard = AdminDashboard.new
  end
end
