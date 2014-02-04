class DashboardsController < ApplicationController
  before_filter :authenticate_admin!

  def show
    @dashboard = AdminDashboard.new(orders_page_param)
  end

  private

  def orders_page_param
    { orders_page: params[:orders_page] || 1 }
  end
end
