class CreateCategoryItems < ActiveRecord::Migration
  def change
    create_table :category_items do |t|
      t.references :item, index: true
      t.references :category, index: true

      t.timestamps
    end
  end
end
