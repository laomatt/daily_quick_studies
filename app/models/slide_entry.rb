class SlideEntry < ActiveRecord::Base
  belongs_to :slide
  belongs_to :slideshow
end
