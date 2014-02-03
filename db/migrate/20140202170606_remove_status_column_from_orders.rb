class RemoveStatusColumnFromOrders < ActiveRecord::Migration
  def change
    remove_column :orders, :status
  end
end
