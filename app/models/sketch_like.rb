class SketchLike < ApplicationRecord
	belongs_to :sketch
	belongs_to :user
	validates :user_id, :presence => true, :uniqueness => {:scope => :sketch_id}
end
