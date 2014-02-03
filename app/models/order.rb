class Order < ActiveRecord::Base
  has_many :line_items
  belongs_to :user
  accepts_nested_attributes_for :line_items

  after_save :update_finalized_timestamp

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

  def completed?
    complete
  end

  def status
    if canceled?
      "canceled"
    elsif completed?
      "completed"
    elsif paid?
      "paid"
    else
      "ordered"
    end
  end

  def update_finalized_timestamp
    if canceled_changed? || complete_changed?
      touch :finalized_at
    end
  end

  def user_name
    user.full_name
  end

  def user_email
    user.email
  end
end
