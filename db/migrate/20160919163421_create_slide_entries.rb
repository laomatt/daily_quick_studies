class CreateSlideEntries < ActiveRecord::Migration
  def change
    create_table :slide_entries do |t|
      t.integer :slide_id
      t.integer :slideshow_id

      t.timestamps null: false
    end
  end
end
