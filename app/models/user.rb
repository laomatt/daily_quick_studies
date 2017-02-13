class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:facebook]

  has_many :slides
  has_many :slideshows
  has_many :slide_likes
  has_many :sketches

 def self.from_omniauth(auth)
    if User.exists?(:email => auth.info.email)
      user = User.find_by_email(auth.info.email)
      user.update_attributes(avatar_url: auth.info.image)
      user
    else
      user = User.create(name: auth.extra.raw_info.name, email: auth.info.email, avatar_url: auth.info.image, password: Devise.friendly_token[0,20])
    end
    user
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end


  def slideshows_with_out(slide_id)
    slide = Slide.find(slide_id)
    already = slide.slide_entries.map { |e| e.slideshow_id }
    slideshows.to_a.delete_if { |e| already.include?(e.id) }
  end

  def portrait_url
    avatar_url || 'http://placehold.it/150x150'
  end
end
