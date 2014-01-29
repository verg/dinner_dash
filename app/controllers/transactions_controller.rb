class TransactionsController < ApplicationController
  before_filter :authenticate_user!
  after_filter :destroy_cart, only: [:create]

  def new
    @cart = current_cart
    @payment_gateway_key = PaymentGateway.public_key
  end

  def create
    customer_id = payment_gateway.find_or_create_customer_id(
      current_user,
      customer_email,
      card_token
    )

    order = create_order
    payment_description = description_for(order)

    payment_gateway.create_charge(customer_id, amount_in_cents, payment_description)
    set_order_status_to_paid(order)
    redirect_to root_path

  rescue PaymentGateway::CardError => e
    order.destroy if order
    flash[:error] = e.message
    redirect_to new_transaction_path
  end

  private

  def payment_gateway
    @payment_gateway ||= PaymentGateway.new
  end

  def customer_email
    params["stripeEmail"]
  end

  def card_token
    params[:stripeToken]
  end

  def create_order
    Order.create_from_cart(current_cart, status: "ordered")
  end

  def description_for(order)
    "Order: #{order.id}"
  end

  def amount_in_cents
    current_cart.total_price_cents
  end

  def set_order_status_to_paid order
    order.status = "paid"
    order.save
  end

  def destroy_cart
    current_cart.destroy
  end
end
