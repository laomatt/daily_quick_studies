class Slide < ActiveRecord::Base
  belongs_to :user
  validates :user_id, presence: true
  has_many :slide_entries, :class_name => 'SlideEntry'
  has_many :taggings, :class_name => 'Tagging'
  has_many :slide_likes
  has_many :tags, :through => :taggings
  self.per_page = 20

  def self.random_three
    all.shuffle.first(5)
  end

  def self.search(phrase)
    slides_reg = Slide.where('name like ?', "%#{phrase}%")
    slide_u = Slide.where('name like ?', "%#{phrase.upcase}%")
    slide_l = Slide.where('name like ?', "%#{phrase.downcase}%")

    slides_reg + slide_u + slide_l
  end

  def self.name_all
    all.each do |s|
      name = s.file.to_s.split('/').last
      s.update_attributes(:name => name)
    end
  end

  def uniq_tags
    tags.uniq {|e| e.name}
  end

  def tags_list
    uniq_tags.map { |e| e.name }.join(', ')
  end

  module Uploader
    class FileUploader < CarrierWave::Uploader::Base
      include CarrierWave::MiniMagick

      process :convert => 'jpg'
      storage :fog

      def store_dir
        "dq/uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
      end

      def cache_dir
        "/tmp/uploads"
      end

      def file_name
        'filename.jpeg'
      end

      def self.fog_public
        true
      end

      version :thumb do
        process :resize_to_fill => [400, 400]
        process :convert => 'jpg'
      end

    end
  end

  mount_uploader :file, Uploader::FileUploader
end
