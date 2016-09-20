class Slideshow < ActiveRecord::Base
  belongs_to :user, :class_name => 'User'
  has_many :slide_entries, :class_name => 'SlideEntry'
  has_many :slides, :through => :slide_entries

  def preview
    if slides.present?
      slides.sample.file.thumb.url
    else
      'http://placehold.it/250x250'
    end
  end

  def rand_preview
    slides.shuffle.first(3)
  end
end
