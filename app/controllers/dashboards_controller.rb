class DashboardsController < ApplicationController
  before_filter :authenticate_admin!

  def show
    @dashboard = AdminDashboard.new(filter_orders_params)
  end

  private

  def filter_orders_params
    params.permit(:orders_page, :order_status)
  end
end
