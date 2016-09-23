class Slideshow < ActiveRecord::Base
  belongs_to :user, :class_name => 'User'
  has_many :slide_entries, :class_name => 'SlideEntry'
  has_many :slides, :through => :slide_entries
  self.per_page = 10

  def self.create_show(name, phrase, user_id)
    slides_reg = Slide.where('name like ?', "%#{phrase}%")
    slide_u = Slide.where('name like ?', "%#{phrase.upcase}%")
    slide_l = Slide.where('name like ?', "%#{phrase.downcase}%")

    slides = slides_reg + slide_u + slide_l

    ss = Slideshow.create(:name => name, :user_id => user_id)

    slides.each do |s|
      SlideEntry.create(:slideshow_id => ss.id, :slide_id => s.id)
    end
  end

  def self.rand_shows
    where('public = ?', true).shuffle.first(5)
  end

  def self.public_shows
    where('public = ?', true)
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
