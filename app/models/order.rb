class Order < ActiveRecord::Base
  has_many :line_items
  belongs_to :user

  def self.create_from_cart(cart, opts={})
    opts = opts.merge(user: cart.user)
    order = new(opts)
    order.line_items << cart.line_items
    order.save ? order : false
  end

  def total_price
    line_items.includes(:product).reduce(Money.new(0)) { |sum, item|
      sum + item.total_price
    }
  end

  def self.for_user(user_or_user_id)
    where(user_id: user_or_user_id.to_param)
  end
end
