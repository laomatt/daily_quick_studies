class SketchLikesController < ApplicationController
	# layout: false
	def create
		user_id = current_user.id
		slide_id = params[:slide_id]

		slide = SketchLike.new(:user_id => user_id, :sketch_id => slide_id)
		if slide.save
			render :json => { :message => 'success', :slide => slide }
		else
			render :json => { :message => 'fail', :errors => sketch.errors.full_messages }
		end
		
	end

	def unlike_sketch
		like = current_user.sketch_likes.find_by(:slide_id => params[:slide_id])
		if like.delete
			render :json => { :message => 'success', :slide => like }
		else
			render :json => { :message => 'fail' }
		end
	end

	def check
		if SketchLike.exists?(:sketch_id => params[:sketch_id], :user_id => current_user.id)
			render :json => { :message => 'already liked'}
		else
			render :json => { :message => 'not liked'}
		end
	end
end
