class AddDisplayRankToProducts < ActiveRecord::Migration
  def change
    add_column :products, :display_rank, :integer, default: 10
  end
end
