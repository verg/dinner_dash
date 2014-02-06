require 'sidekiq'

class EmailReceiptWorker
  include Sidekiq::Worker

  def perform(user_id, order_id, mailer=TransactionMailer)
    user = User.find(user_id)
    order = Order.find(order_id)
    message = mailer.receipt(user, order)
    message.delivier
  end
end
