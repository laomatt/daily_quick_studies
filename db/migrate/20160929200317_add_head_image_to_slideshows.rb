class AddHeadImageToSlideshows < ActiveRecord::Migration
  def change
    add_column :slideshows, :head_image, :string
  end
end
