class CreateChatroomMembers < ActiveRecord::Migration[5.0]
  def change
    create_table :chatroom_members do |t|
    	t.integer :user_id
    	t.integer :chatroom_id

      t.timestamps
    end
  end
end
