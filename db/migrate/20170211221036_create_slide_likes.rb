class CreateSlideLikes < ActiveRecord::Migration[5.0]
  def change
    create_table :slide_likes do |t|
    	t.integer :user_id
    	t.integer :slide_id

      t.timestamps
    end
  end
end
