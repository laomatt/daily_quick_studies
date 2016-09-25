class SlideEntry < ActiveRecord::Base
  belongs_to :slide, :dependent => :destroy
  belongs_to :slideshow, :dependent => :destroy

  validates_uniqueness_of :slideshow_id, :scope => :slide_id, :message => 'Slide already exists in this slideshow'
end
