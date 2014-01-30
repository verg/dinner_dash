class UsePaperclipForProductPhoto < ActiveRecord::Migration
  def change
    remove_column :products, :photo
    add_attachment :products, :phoo
  end
end
