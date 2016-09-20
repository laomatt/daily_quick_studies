class CreateSlideshows < ActiveRecord::Migration
  def change
    create_table :slideshows do |t|
      t.string :name
      t.integer :user_id

      t.timestamps null: false
    end

    add_column :slides, :slideshow_id, :integer
  end
end
