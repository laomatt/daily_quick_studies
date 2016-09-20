class RemoveSlideshowIdFromSlides < ActiveRecord::Migration
  def change
    remove_column :slides, :slideshow_id
  end
end
