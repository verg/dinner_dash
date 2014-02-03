class AddStatusBooleansToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :paid, :boolean, default: false, index: true
    add_column :orders, :complete, :boolean, default: false
    add_column :orders, :canceled, :boolean, default: false
  end
end
