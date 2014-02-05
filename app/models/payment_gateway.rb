class PaymentGateway
  class CardError < StandardError; end
  class RegistrationError < StandardError; end

  def initialize(opts={})
    @customer_gateway = opts.fetch(:customer_gateway) { Stripe::Customer }
    @charge_gateway = opts.fetch(:charge_gateway) { Stripe::Charge }
  end

  def create_charge(customer_id, amount, order, currency=default_currency)
    begin
      charge = @charge_gateway.create(
        customer: customer_id,
        amount: amount,
        description: description_for(order),
        currency: currency
      )
      return persist_transaction(charge, order)
    rescue Stripe::InvalidRequestError => e
      raise PaymentGateway::CardError, e.message
    end
  end

  def find_or_create_customer_id(user, email, card_token)
    return user.stripe_customer_id if user.stripe_customer_id

    begin
      customer = @customer_gateway.create(email: email, card: card_token)
      persist_customer_id(user, customer.id)
      customer.id
    rescue Stripe::InvalidRequestError => e
      raise PaymentGateway::CardError, e.message
    end
  end

  def self.public_key
    Rails.configuration.stripe[:publishable_key]
  end

  private

  def default_currency
    Rails.configuration.stripe[:default_currency]
  end

  def persist_customer_id(user, customer_id, cust_id_attr=:stripe_customer_id)
    user[cust_id_attr] = customer_id
    user.save
  end

  def persist_transaction(charge, order)
    Transaction.create!( order_id: order.id,
                         vendor: "stripe",
                         external_id: charge.id,
                         last_four: charge.card.last4,
                         card_type: charge.card.type
                       )
  end

  def description_for(order)
    "Order: #{order.id}"
  end
end
