class SlidesController < ApplicationController
  layout 'public'
  before_action :set_slide, only: [:show, :edit, :update, :destroy, :inspect_modal]
  before_action :authenticate_user!, except: [:inspect_modal]
  # GET /slides
  # GET /slides.json
  def index
    @slides = Slide.paginate(:page => 1, :per_page => 8)
    @page = 'slides'
  end

  # GET /slides/1
  # GET /slides/1.json
  def show
  end

  # GET /slides/new
  def new
    @slide = Slide.new
  end

  # GET /slides/1/edit
  def edit
  end

  def account_slides
    @page = 'account_slides'

  end

  def account_liked_slides
    @page = 'account_liked_slides'
  end

  def general_slide_page
    @slides = Slide.paginate(:page => params[:page], :per_page => 8)
    render :partial => 'slide_page', :locals => { :slides => @slides }
  end

  def reload_pag
    @slides = Slide.paginate(:page => params[:page])
    render :partial => 'results', :locals => { :slides => @slides, :from => 'general' }
  end

  def reload_pag_account
    @slides = Slide.where('user_id = ?', current_user.id).paginate(:page => params[:page])
    render :partial => 'results', :locals => { :slides => @slides, :from => 'account' }
  end

  def inspect_modal
    from = params[:from]
    render :partial => 'inspect', :locals => { :src => @slide.file.url, :slide => @slide, :from => from }
  end

  def update_name
    @slide.update_attributes(:name => params[:name])
    render :nothing => true
  end

  def search_reload_pag
    from = params[:from]

    if from == 'account'
      @slides = Slide.includes(:tags).where('lower(slides.name) like ? or lower(tags.name) like ? and user_id = ?',"%#{params[:search].downcase}%", "%#{params[:search].downcase}%", current_user.id).references(:tags)
    else
      @slides = Slide.includes(:tags).where('lower(slides.name) like ? or lower(tags.name) like ?',"%#{params[:search].downcase}%", "%#{params[:search].downcase}%").references(:tags)
    end

    if params[:slideshow_id].present?
      slides = Slideshow.find(params[:slideshow_id]).slides.map { |e| e.id }
      if from == 'account'
        @slides = Slide.includes(:tags).where('lower(slides.name) like ? or lower(tags.name) like ? and user_id = ? and slides.id not in(?)',"%#{params[:search].downcase}%", "%#{params[:search].downcase}%", current_user.id, slides).references(:tags)
      else
        @slides = Slide.includes(:tags).where('lower(slides.name) like ? or lower(tags.name) like ? and slides.id not in (?)',"%#{params[:search].downcase}%", "%#{params[:search].downcase}%", slides).references(:tags)
      end
    end

    render :partial => 'results', :locals => { :slides => @slides, :from => from }
  end

  def search_reload_pag_row
    @slides = Slide.where('lower(name) like ?',"%#{params[:search].downcase}%").paginate(:page => params[:page])
    render :partial => 'results', :locals => { :slides => @slides, :from => 'modal' }
  end

  def slides_modal
    render :partial => 'random_slides'
  end

  # POST /slides
  # POST /slides.json
  def create
    uploaded_io = params[:image_this]
    slide = Slide.new
    slide.user_id = current_user.id
    slide.file = uploaded_io
    if slide.save
      if params[:name].present?
        name = params[:name]
      else
        name = slide.file.to_s.split('/').last
      end

      if params[:tags].present?
        params[:tags].split(',').each do |tag|
          t = Tag.find_or_create_by(:name => tag)
          Tagging.create(:tag_id => t.id, :slide_id => slide.id, :user_id => current_user.id)
        end
      end

      slide.update_attributes(:name => name)
      out = 'success'
    else
      out = 'fail'
    end
    render :json => { :outcome => out, :url => slide.file.thumb.url }
  end

  # PATCH/PUT /slides/1
  # PATCH/PUT /slides/1.json
  def update
    respond_to do |format|
      if @slide.update(slide_params)
        format.html { redirect_to @slide, notice: 'Slide was successfully updated.' }
        format.json { render :show, status: :ok, location: @slide }
      else
        format.html { render :edit }
        format.json { render json: @slide.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /slides/1
  # DELETE /slides/1.json
  def destroy
    @slide.destroy
    render :nothing => true
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_slide
      @slide = Slide.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def slide_params
      params.require(:slide).permit(:name, :slides_to_add, :file)
    end
  end
