class OrdersController < ApplicationController
  before_filter :authenticate_user!, except: [:cancel, :paid, :complete, :edit, :update]
  before_action :verify_correct_user, except: [:cancel, :paid, :complete, :edit, :update]

  before_action :authenticate_admin!, except: [:index, :show]

  def index
    @orders = Order.for_user(user_id)
  end

  def show
    @order = Order.includes(line_items: [:product]).find_by(id: order_id)
  end

  def cancel
    update_status(:canceled)
    redirect_to dashboard_path
  end

  def paid
    update_status(:paid)
    redirect_to dashboard_path
  end

  def complete
    update_status(:complete)
    redirect_to dashboard_path
  end

  def edit
    @order = Order.find(order_id)
  end

  def update
    @order = Order.find(order_id)

    if @order.update_attributes(order_params) &&
      LineItem.update(line_item_ids, line_item_attributes).all?(&:valid?)

      redirect_to dashboard_path
    else
      render :edit
    end
  end

  private

  def order_params
    params.require(:order).permit(:complete, :paid, :canceled)
  end

  def line_item_ids
    line_item_params.map { |line_item| line_item[:id] }
  end

  def line_item_attributes
    line_item_params.map{|li| li.reject{|k,v| k == "id" } }
  end

  def line_item_params
    @line_item_params ||= params.require(:order).permit(
      :line_items_attributes => [:quantity, :id]
    )[:line_items_attributes].values
  end

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

  def update_status(status)
    order = Order.find(order_id)
    order.update_attributes(status => true)
    order.save
  end
end
