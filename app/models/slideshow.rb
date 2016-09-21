class Slideshow < ActiveRecord::Base
  belongs_to :user, :class_name => 'User'
  has_many :slide_entries, :class_name => 'SlideEntry'
  has_many :slides, :through => :slide_entries
  self.per_page = 3

  def self.create_show(name, phrase, user_id)
    slides = Slide.where('name like ?', "%#{phrase}%")
    ss = Slideshow.create(:name => name, :user_id => user_id)

    slides.each do |s|
      SlideEntry.create(:slideshow_id => ss.id, :slide_id => s.id)
    end
  end

  def self.rand_shows
    all.shuffle.first(3)
  end

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
