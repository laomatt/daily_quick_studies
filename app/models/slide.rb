class Slide < ActiveRecord::Base
  belongs_to :user
  has_many :slide_entries, :class_name => 'SlideEntry'
  has_many :taggings, :class_name => 'Tagging'

  def self.random_three
    all.shuffle.first(5)
  end

  def self.name_all
    all.each do |s|
      name = s.file.to_s.split('/').last
      s.update_attributes(:name => name)
    end
  end

  module Uploader
    class FileUploader < CarrierWave::Uploader::Base
      # include CarrierWave::Backgrounder::Delay
      include CarrierWave::MiniMagick

      process :convert => 'jpeg'
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
        process :convert => 'jpeg'
      end

    end
  end

  mount_uploader :file, Uploader::FileUploader
  # process_in_background :file
  # store_in_background :file
end
