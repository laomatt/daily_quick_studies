class Tag < ActiveRecord::Base
  has_many :taggings, :class_name => 'Tagging'

  validates :name, presence: true, uniqueness: true
end
