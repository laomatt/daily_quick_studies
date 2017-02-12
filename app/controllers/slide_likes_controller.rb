class SlideLikesController < ApplicationController

	def create
		user_id = current_user.id
		slide_id = params[:slide_id]

		slide = SlideLike.new(:user_id => user_id, :slide_id => slide_id)
		if slide.save
			render :json => { :message => 'success', :slide => slide }
		else
			render :json => { :message => 'fail', :errors => slide.errors.full_messages }
		end
	end

	def unlike_slide
		like = current_user.slide_likes.find_by(:slide_id => params[:slide_id])
		if like.delete
			render :json => { :message => 'success', :slide => like }
		else
			render :json => { :message => 'fail' }
		end
		
	end
end
