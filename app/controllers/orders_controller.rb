class OrdersController < ApplicationController
  before_filter :authenticate_user!
  before_action :verify_correct_user, only: :index

  def new
    @order = Order.new
  end

  def index
    @orders = Order.where(user_id: user_id)
  end

  private

  def user_id
    params[:user_id]
  end

  def verify_correct_user
    if user_id.to_i != current_user.id
      redirect_to user_orders_path(current_user.id)
    end
  end
end
