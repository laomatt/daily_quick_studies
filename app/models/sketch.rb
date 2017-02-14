class Sketch < ApplicationRecord
	belongs_to :user
	belongs_to :slide
	# has_many :sketch_likes

  def name
    file.file_name
  end
  
	module Uploader
    class FileUploader < CarrierWave::Uploader::Base
      include CarrierWave::MiniMagick

      process :convert => 'jpg'
      storage :fog

      def store_dir
        "dq/uploads/sketches/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
      end

      def cache_dir
        "/tmp/uploads"
      end

      def file_name
        'sketch.jpeg'
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
