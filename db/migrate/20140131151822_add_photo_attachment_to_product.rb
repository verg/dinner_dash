class AddPhotoAttachmentToProduct < ActiveRecord::Migration
  def change
    remove_attachment :products, :phoo
    add_attachment :products, :photo
  end
end
