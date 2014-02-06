require "spec_helper"

describe TransactionMailer do
  let(:user) { create(:user) }
  let(:order) { create(:order, user: user, paid: true) }

  describe "#transaction_receipt" do
    subject(:email) { TransactionMailer.receipt(user, order) }

    it "delivers to the invoice email" do
      expect(email).to deliver_to(user.email)
      expect(email).to have_subject "Your Receipt"
      expect(email).to have_body_text(/#{order.total_price}/)
    end
  end
end
