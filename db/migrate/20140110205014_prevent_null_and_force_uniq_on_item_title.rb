class PreventNullAndForceUniqOnItemTitle < ActiveRecord::Migration
  def change
    change_column :items, :title, :string, null: false
    add_index :items, :title, unique: true
  end
end
