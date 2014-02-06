class TransactionMailer < ActionMailer::Base
  default from: "from@example.com"

  def receipt(user, order)
    @user = user
    @order = order

    mail(
      to: user.email,
      subject: "Your Receipt"
      )
  end
end
