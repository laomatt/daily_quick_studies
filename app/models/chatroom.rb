class Chatroom < ApplicationRecord
	belongs_to :user
	has_many :messages
	has_many :chatroom_members
end
