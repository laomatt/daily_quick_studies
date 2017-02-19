class CreateSketchLikes < ActiveRecord::Migration[5.0]
  def change
    create_table :sketch_likes do |t|
    	t.integer :sketch_id
    	t.integer :user_id

      t.timestamps
    end
  end
end
