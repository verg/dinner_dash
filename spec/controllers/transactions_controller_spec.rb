require 'spec_helper'

describe TransactionsController do
  describe "GET #new" do
    it "displays the transaction form" do
      sign_in create(:user)
      get :new
      expect(response).to render_template :new
    end

    it "denies access for non-authenticated users" do
      not_signed_in = create(:user)
      get :new, user_id: not_signed_in
      expect(response).to redirect_to new_user_session_path
    end
  end

  describe "POST #create" do
    it "denies access for non-authenticated users" do
      not_signed_in = create(:user)
      post :create, user_id: not_signed_in
      expect(response).to redirect_to new_user_session_path
    end

    describe "with a sucessful transaction" do
      it "creates a new order" do
        sign_in create(:user, stripe_customer_id: "id")
        PaymentGateway.any_instance.stub(:create_charge)

        expect{
          post :create, stripeToken: "tok_103OXi2MiUtVpB73G4i2I4CQ",
          stripeEmpil: "user@example.com"
        }.to change(Order, :count).by(1)
      end

      it "sends a charge to the payment gateway" do

        price = 500
        sign_in create(:user, stripe_customer_id: "id")
        @controller.current_cart.stub(:total_price_cents).and_return(price)

        PaymentGateway.any_instance.should_receive(:create_charge).
          with("id", price, /Order: \d+/)

        post :create, stripeToken: "tok_103OXi2MiUtVpB73G4i2I4CQ",
          stripeEmpil: "user@example.com"
      end

      it "redirects to the root path" do
        sign_in create(:user, stripe_customer_id: "id")
        PaymentGateway.any_instance.stub(:create_charge)

        post :create, stripeToken: "tok_103OXi2MiUtVpB73G4i2I4CQ",
          stripeEmpil: "user@example.com"
        expect(response).to redirect_to root_path
      end
    end

    describe "when an error occurs" do
      it "redirects to the new transaction path" do
        PaymentGateway.any_instance.stub(:find_or_create_customer_id).
          and_raise(PaymentGateway::CardError)

        sign_in create(:user)
        post :create, stripeToken: "bad token",
          stripeEmpil: "user@example.com"
        expect(response).to redirect_to new_transaction_path
      end

      it "doesn't persist a new order" do
        PaymentGateway.any_instance.stub(:find_or_create_customer_id).
          and_raise(PaymentGateway::CardError)

        sign_in create(:user)
        expect {
          post :create, stripeToken: "bad token",
          stripeEmpil: "user@example.com"
        }.not_to change(Order, :count)
      end
    end
  end
end
