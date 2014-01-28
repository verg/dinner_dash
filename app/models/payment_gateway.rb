class PaymentGateway
  class CardError; end
  class RegistrationError; end

  def initialize(opts={})
    @customer_gateway = opts.fetch(:customer_gateway) { Stripe::Customer }
    @charge_gateway = opts.fetch(:charge_gateway) { Stripe::Charge }
  end

  def create_charge(customer_id, amount, description, currency=nil)
    currency = default_currency unless currency

    begin
      @charge_gateway.create(
        customer: customer_id,
        amount: amount,
        description: description,
        currency: currency
      )
    rescue Stripe::InvalidRequestError => e
      raise PaymentGateway::CardError, e.message
    end
  end

  def find_or_create_customer_id(user, email, card_token)

    return user.stripe_customer_id if user.stripe_customer_id

    begin
      customer = @customer_gateway.create(email: email, card: card_token)
      persist_customer_id(user, customer.id)
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
end
