class MoveLineItemReferenceFromOrderToLineItem < ActiveRecord::Migration
  def change
    remove_column :orders, :line_item_id
    add_column :line_items, :order_id, :integer, index: true
  end
end
