class OrdersController < ApplicationController
  before_filter :authenticate_user!
  before_action :verify_correct_user

  def index
    @orders = Order.for_user(user_id)
  end

  def show
    @order = Order.includes(line_items: [:product]).find_by(id: order_id)
    if order_finished?(@order)
      @final_status_timestamp = @order.updated_at
    end
  end

  private

  def user_id
    params[:user_id]
  end

  def order_id
    params[:id]
  end

  def verify_correct_user
    if user_id.to_i != current_user.id
      redirect_to user_orders_path(current_user.id)
    end
  end

  def order_finished?(order)
    order.status == "completed" || order.status == "canceled"
  end
end
