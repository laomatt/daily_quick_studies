class AddPublicBooleanToSlideshows < ActiveRecord::Migration
  def change
    add_column :slideshows, :public, :boolean, :default => false, :null => false

    Slideshow.all.each do |ss|
      ss.update_attributes(:public => true)
    end
  end
end
