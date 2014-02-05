class TransactionReceipt < ActionMailer::Base
  default from: "from@example.com"

  def transaction_receipt(user, order)
    @user = user
    @order = order

    mail(
      to: user.email,
      subject: "Your Receipt"
      )
  end
end
