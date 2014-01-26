class Order < ActiveRecord::Base
  belongs_to :line_item
  belongs_to :user
end
