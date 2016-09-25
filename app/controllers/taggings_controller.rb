class TaggingsController < ApplicationController

  def create
    tag = Tag.find(params[:tag_id])
    tagging = Tagging.create(:user_id => current_user.id, :tag_id => tag.id, :slide_id => params[:slide_id])

    render :partial => 'current_tag', :locals => { :tag => tag }
  end

  def delete_tag_from_slide
    status = 'fail'
    tag = Tag.find(params[:id])
    slide = Slide.find(params[:slide_id])

    taggings = Tagging.where('tag_id = ? and slide_id = ?', tag.id, slide.id)

    taggings.each(&:delete)

    if tag.delete
      status = 'success'
    end

    render :json => {:status => status}
  end

  def create_tag
    tag = Tag.create(:name => params[:phrase])
    slide = Slide.find(params[:slide_id])
    tagging = Tagging.create(:tag_id => tag.id, :user_id => current_user.id, :slide_id => slide.id)

    render :partial => 'current_tag', :locals => { :tag => tag }

  end

  def tag_results
    @tags = Tag.where('lower(name) like ?',"%#{params[:phrase].downcase}%")

    if @tags.present?
      render :partial => 'tag_list_results', :locals => {:tags => @tags.uniq {|e| e.name}, :type => 'search'}
    else
      render :partial => 'create_tag_button', :locals => { :phrase => params[:phrase]}
    end
  end
end
