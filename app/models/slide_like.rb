class SlideLike < ApplicationRecord
	belongs_to :user
	belongs_to :slide

	validates :user_id, :presence => true, :uniqueness => {:scope => :slide_id}
	# def method_name
		
	# end
end
