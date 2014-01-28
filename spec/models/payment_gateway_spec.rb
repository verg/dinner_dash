require 'spec_helper'

class FakeStripe;end

describe PaymentGateway do
  describe ".publishable_key" do
    it "returns the payment gateway key from rails configuration" do
      Rails.configuration.stripe = { publishable_key: "abc" }
      expect(PaymentGateway.public_key).to eq "abc"
    end
  end

  describe "#find_or_create_customer_id" do
    let(:email) { "bob@example.com" }
    let(:card_token) { "tok_103OTD2MiUtVpB73jmBEkeoK" }
    let(:gateway) { PaymentGateway.new(customer_gateway: FakeStripe) }

    describe "when the user has a payment customer id" do
      it "finds returns the user's customer id " do
        user = create(:user, stripe_customer_id: "the_id")
        customer_id = gateway.find_or_create_customer_id(user, email, card_token)
        expect(customer_id).to eq "the_id"
      end
    end

    describe "when the user doesn't have payment customer id" do
      it "sends a request to the payment gateway to create a new customer" do
        user = build(:user)
        FakeStripe.stub(:create) { double("fake customer", id: "xyz_id") }

        FakeStripe.should_receive(:create).with(email: email, card: card_token)
        gateway.find_or_create_customer_id(user, email, card_token)
      end

      it "persists the customer id to the user's record" do
        user = build(:user)
        customer_id = "xyz"
        FakeStripe.stub(:create) { double("fake customer", id: customer_id) }

        gateway.find_or_create_customer_id(user, email, card_token)
        expect(user.stripe_customer_id).to eq customer_id
      end
    end
  end

  describe "#create_charge" do
    it "does something" do
      Rails.configuration.stripe[:default_currency] = "usd"
      amount = 499
      customer_id = 1231233
      description = "order 1034233"

      FakeStripe.should_receive(:create).with(
        customer: customer_id,
        amount: amount,
        description: description,
        currency: "usd"
      )

      gateway = PaymentGateway.new(charge_gateway: FakeStripe)
      gateway.create_charge(customer_id, amount, description)
    end
  end
end

