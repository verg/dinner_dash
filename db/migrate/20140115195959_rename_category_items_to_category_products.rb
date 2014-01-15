class RenameCategoryItemsToCategoryProducts < ActiveRecord::Migration
  def change
    rename_column :category_items, :item_id, :product_id
    rename_table :category_items, :category_products
  end
end
