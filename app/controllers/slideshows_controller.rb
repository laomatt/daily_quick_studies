class SlideshowsController < ApplicationController
  before_action :set_slideshow, only: [:show, :edit, :update, :destroy, :draw_modal, :add_slide_to_slideshow], except: [:create_show]
  before_action :authenticate_user!, except: [:regen_rand, :draw_random, :draw_modal, :draw_pose, :show]

  # GET /slideshows
  # GET /slideshows.json
  def index
    @slideshows = Slideshow.all
    @pag_url = '/slideshows/reload_pag'
    @page = 'home'
  end

  # GET /slideshows/1
  # GET /slideshows/1.json
  def show
  end

  # GET /slideshows/new
  def new
    @slideshow = Slideshow.new
  end

  def create_show
    slideshow = Slideshow.create(:name => params[:name], :user_id => current_user.id, :public => true)
    if params[:slideshow].present? && params[:slideshow][:slides_to_add].present?
      params[:slideshow][:slides_to_add].values.each do |slide|
        SlideEntry.create(:slide_id => slide, :slideshow_id => slideshow.id)
      end
    end

    slideshow.update_tag_list

    render :partial => 'slideshow_list_sect', :locals => { :slideshows => current_user.slideshows.paginate(:page => params[:page]), :context_page => 'account', :pag_url => '/slideshows/reload_pag_user' }
  end

  # GET /slideshows/1/edit
  def edit
    render :partial => 'edit_slideshow', :locals => { :slideshow => @slideshow}

  end

  def reload_pag
    render :partial => 'slideshow_list_sect', :locals => { :slideshows => Slideshow.public_shows.paginate(:page => params[:page]), :context_page => 'general' }
  end

  def search_slideshows
    phrase = params[:phrase]

    slideshows = Slideshow.where('lower(name) like ? or lower(tags_list) like ?', "%#{phrase.downcase}%", "%#{phrase.downcase}%")
    render :partial => 'slideshow_list_sect', :locals => { :slideshows => slideshows.paginate(:page => params[:page]), :context_page => 'general' }

  end

  def regen_rand
    render :partial => '/slideshows/slideshow_list_sect', :locals => { :slideshows => Slideshow.rand_shows, :context_page => 'general' }
  end

  def reload_pag_user
    render :partial => 'slideshow_list_sect', :locals => { :slideshows => current_user.slideshows.paginate(:page => params[:page]), :context_page => 'account' }
  end

  def draw_modal
    render :partial => 'draw_modal', :locals => {:slideshow => @slideshow, :type => 'indiv'}
  end

  def add_slide_to_slideshow
    @slide = Slide.find(params[:slide_id])
    se = SlideEntry.new(:slideshow_id => @slideshow.id, :slide_id => @slide.id)
    # byebug
    if se.save
      render :json => { :status => 'success', :message => "#{@slide.name} successfully added to #{@slideshow.name}" }
    else
      render :json => { :status => 'error', :message => "#{se.errors.full_messages.join(', ')}" }
    end

  end

  def draw_random
    render :partial => 'draw_modal', :locals => {:slides => Slide.all , :type => 'random'}
  end

  def draw_pose
    if params[:type] == 'random'
      ids = Slide.all.shuffle.first(params[:amount].to_i).map { |e| e.file.url }
    else
      @slideshow = Slideshow.find(params[:id])
      srcs = @slideshow.slides.shuffle.first(params[:amount].to_i).map { |e| e.file.url }
      ids = @slideshow.slides.shuffle.first(params[:amount].to_i).map { |e| e.id }

    end
    render :partial => '/draw_set', :locals => { :slideshow => @slideshow, :pose_length => params[:interval], :pose_number => params[:amount], :srcs => srcs, :ids => ids, :transition_time => params[:transition] }
  end

  # POST /slideshows
  # POST /slideshows.json
  def create
    @slideshow = Slideshow.new(slideshow_params)

    respond_to do |format|
      if @slideshow.save
        format.html { redirect_to @slideshow, notice: 'Slideshow was successfully created.' }
        format.json { render :show, status: :created, location: @slideshow }
      else
        format.html { render :new }
        format.json { render json: @slideshow.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /slideshows/1
  # PATCH/PUT /slideshows/1.json
  def update
    slideshow_params.delete(:slides_to_add)
    slides_to_add_ids = params[:slideshow][:slides_to_add]
    slides_to_remove_ids = params[:slideshow][:slides_to_remove]

    if slides_to_remove_ids.present?
      slides_to_remove = Slide.find(slides_to_remove_ids.values)
      slides_to_remove.each do |slide|
        @slideshow.slide_entries.select { |e| e.slide_id == slide.id }.each do |se|
          se.delete
        end
      end
    end


    if slides_to_add_ids.present?
      slides_to_add = Slide.find(slides_to_add_ids.values)
      slides_to_add.each do |slide|
        se = SlideEntry.new(:slide_id => slide.id, :slideshow_id => @slideshow.id)
        se.save!
      end
    end

    if @slideshow.update(slideshow_params)
      render :partial => 'slideshow_list_sect', :locals => { :slideshows => current_user.slideshows.paginate(:page => params[:page]), :context_page => 'account', :pag_url => '/slideshows/reload_pag_user' }
    else
      render :partial => 'slideshow_list_sect', :locals => { :slideshows => current_user.slideshows.paginate(:page => params[:page]), :context_page => 'account', :pag_url => '/slideshows/reload_pag_user' }
      flash[:error] = "Error Updating: #{@slideshow.errors.full_messages}"
    end
  end

  # DELETE /slideshows/1
  # DELETE /slideshows/1.json
  def destroy
    id = @slideshow.id
    @slideshow.delete
    render :json => {:id => id}
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_slideshow
      @slideshow = Slideshow.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def slideshow_params
      params.require(:slideshow).permit(:name, :public, :head_image)
    end
end
