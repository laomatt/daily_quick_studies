class SlideshowsController < ApplicationController
  before_action :set_slideshow, only: [:show, :edit, :update, :destroy, :draw_modal]

  # GET /slideshows
  # GET /slideshows.json
  def index
    @slideshows = Slideshow.all
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
    if params[:phrase].present?
      Slideshow.create_show(params[:name], params[:phrase], current_user.id)
    else
      Slideshow.create(:name => params[:name], :user_id => current_user.id)
    end
    render :partial => 'slideshow_list_sect', :locals => { :slideshows => current_user.slideshows.paginate(:page => params[:page]), :context_page => 'account' }
  end

  # GET /slideshows/1/edit
  def edit
    render :partial => 'edit_slideshow', :locals => { :slideshow => @slideshow}

  end

  def reload_pag
    render :partial => 'slideshow_list_sect', :locals => { :slideshows => Slideshow.paginate(:page => params[:page]), :context_page => 'account' }
  end

  def reload_pag_user
    render :partial => 'slideshow_list_sect', :locals => { :slideshows => current_user.slideshows.paginate(:page => params[:page]), :context_page => 'account' }
  end

  def draw_modal
    render :partial => 'draw_modal', :locals => {:slideshow => @slideshow, :type => 'indiv'}
  end

  def draw_random
    render :partial => 'draw_modal', :locals => {:slides => Slide.all , :type => 'random'}
  end

  def draw_pose
    if params[:type] == 'random'
      ids = Slide.all.shuffle.first(params[:amount].to_i).map { |e| e.file.url }
    else
      @slideshow = Slideshow.find(params[:id])
      ids = @slideshow.slides.shuffle.first(params[:amount].to_i).map { |e| e.file.url }

    end
    render :partial => '/draw_set', :locals => { :slideshow => @slideshow, :pose_length => params[:interval], :pose_number => params[:amount], :ids => ids, :transition_time => params[:transition] }
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
        se.save
      end
    end

    if @slideshow.update(slideshow_params)
      render :partial => 'slideshow_list_sect', :locals => { :slideshows => current_user.slideshows.paginate(:page => params[:page]), :context_page => 'account' }
    else
      render :partial => 'slideshow_list_sect', :locals => { :slideshows => current_user.slideshows.paginate(:page => params[:page]), :context_page => 'account' }
      flash[:error] = "Error Updating: #{@slideshow.errors.full_messages}"
    end
  end

  # DELETE /slideshows/1
  # DELETE /slideshows/1.json
  def destroy
    @slideshow.destroy
    respond_to do |format|
      format.html { redirect_to slideshows_url, notice: 'Slideshow was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_slideshow
      @slideshow = Slideshow.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def slideshow_params
      params.require(:slideshow).permit(:name, :public)
    end
end
