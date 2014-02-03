class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable
  has_one :cart
  has_many :line_items, through: :cart

  def items_in_cart
    line_items
  end

  def full_name
    "#{firstname} #{lastname}"
  end
end
