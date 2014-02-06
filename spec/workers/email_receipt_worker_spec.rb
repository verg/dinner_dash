require_relative '../../app/workers/email_receipt_worker'

class FakeMailer; end
class User; end
class Order; end

describe EmailReceiptWorker do
  it "instructs the mailer to send a receipt" do
    user_id = 1
    order_id = 1
    user = double("User")
    order = double("Order")
    message = double("Mail")

    User.stub(:find).with(user_id).and_return(user)
    Order.stub(:find).with(order_id).and_return(order)
    FakeMailer.stub(:receipt).and_return(message)

    FakeMailer.should_receive(:receipt).with(user, order)
    message.should_receive(:delivier)

    EmailReceiptWorker.new.perform(user_id, order_id, FakeMailer)
  end
end
