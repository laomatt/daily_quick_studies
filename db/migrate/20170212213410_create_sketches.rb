class CreateSketches < ActiveRecord::Migration[5.0]
  def change
    create_table :sketches do |t|
    	t.integer :user_id
    	t.integer :slide_id
    	t.string :file
    	t.string :name

      t.timestamps
    end
  end
end
