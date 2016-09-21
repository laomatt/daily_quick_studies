class SlidesController < ApplicationController
  layout 'public'
  before_action :set_slide, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  # GET /slides
  # GET /slides.json
  def index
    @slides = Slide.paginate(:page => 1)
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

  def reload_pag
    @slides = Slide.paginate(:page => params[:page])
    render :partial => 'results', :locals => { :slides => @slides }
  end

  def search_reload_pag
    # @slides = Slide.search(params[:search]).paginate(:page => params[:page])
    @slides = Slide.where('lower(name) like ?',"%#{params[:search].downcase}%").paginate(:page => params[:page])
    render :partial => 'results', :locals => { :slides => @slides }
  end

  def slides_modal
    render :partial => 'random_slides'
  end

  # POST /slides
  # POST /slides.json
  def create
    uploaded_io = params[:image_this]
    slide = Slide.new(:name => 'new slide')
    slide.file = uploaded_io
    slide.save!
    render :json => { :url => slide.file.thumb.url }
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
    respond_to do |format|
      format.html { redirect_to slides_url, notice: 'Slide was successfully destroyed.' }
      format.json { head :no_content }
    end
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
