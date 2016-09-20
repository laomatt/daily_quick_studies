class Tagging < ActiveRecord::Base
  belongs_to :tag, :class_name => 'Tag'
  belongs_to :slide, :class_name => 'Slide'
end
