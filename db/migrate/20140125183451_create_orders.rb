class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.references :line_item, index: true
      t.references :user, index: true
      t.string :status

      t.timestamps
    end
  end
end
