class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.string :vendor
      t.string :external_id
      t.string :last_four
      t.string :card_type
      t.integer :order_id, index: true

      t.timestamps
    end
  end
end
