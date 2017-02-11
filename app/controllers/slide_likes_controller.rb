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
end
