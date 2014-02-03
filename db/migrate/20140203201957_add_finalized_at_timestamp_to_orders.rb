class AddFinalizedAtTimestampToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :finalized_at, :datetime
  end
end
