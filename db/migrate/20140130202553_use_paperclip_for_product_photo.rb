class UsePaperclipForProductPhoto < ActiveRecord::Migration
  def change
    remove_column :products, :photo
  end
end
