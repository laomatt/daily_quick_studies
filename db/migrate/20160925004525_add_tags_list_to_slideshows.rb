class AddTagsListToSlideshows < ActiveRecord::Migration
  def change
    add_column :slideshows, :tags_list, :string
  end
end
