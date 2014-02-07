class TransactionsController < ApplicationController
  before_filter :authenticate_user!
  after_filter :destroy_cart, only: [:create]

  def new
    @cart = current_cart
    @payment_gateway_key = PaymentGateway.public_key
  end

  def create
    if paid_with_card?
      customer_id = get_customer_id_from_payment_gateway
      order = create_order
      payment_gateway.create_charge( customer_id, amount_in_cents, order )
      set_order_status_to_paid(order)
      mail_receipt(order)
    else
      create_order
    end

    flash[:notice] = "Thanks for your order."
    redirect_to root_path

  rescue PaymentGateway::CardError => e
    order.destroy if order
    flash[:error] = e.message
    redirect_to new_transaction_path
  end

  private

  def paid_with_card?
    customer_email && card_token ? true : false
  end

  def customer_email
    @customer_email ||= params["stripeEmail"]
  end

  def card_token
    @card_token ||= params[:stripeToken]
  end

  def get_customer_id_from_payment_gateway
    payment_gateway.find_or_create_customer_id(
      current_user,
      customer_email,
      card_token
    )
  end

  def payment_gateway
    @payment_gateway ||= PaymentGateway.new
  end

  def create_order
    Order.create_from_cart(current_cart)
  end

  def amount_in_cents
    current_cart.total_price_cents
  end

  def set_order_status_to_paid order
    order.update_attributes(paid: true)
    order.save
  end

  def destroy_cart
    current_cart.destroy
  end

  def mail_receipt(order)
    EmailReceiptWorker.perform_async(current_user.id, order.id)
  end
end
