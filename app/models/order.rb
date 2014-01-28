class Order < ActiveRecord::Base
  has_many :line_items
  belongs_to :user

  def self.create_from_cart(cart, opts={})
    opts = opts.merge(user: cart.user)
    order = new(opts)
    order.line_items << cart.line_items
    order.save ? order : false
  end
end
