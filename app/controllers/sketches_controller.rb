class SketchesController < ApplicationController
  before_action :set_sketch, only: [:show, :edit, :update, :destroy]

  # GET /sketches
  # GET /sketches.json
  def index
    @sketches = Sketch.all
  end

  # GET /sketches/1
  # GET /sketches/1.json
  def show
  end

  # GET /sketches/new
  def new
    @sketch = Sketch.new
  end

  # GET /sketches/1/edit
  def edit
  end

  # POST /sketches
  # POST /sketches.json
  def create
    return if params[:image_this].nil?
    uploaded_io = params[:image_this]
    sketch = Sketch.new
    sketch.user_id = current_user.id
    sketch.slide_id = params[:slide_id]
    sketch.file = uploaded_io
    if sketch.save
      if params[:name].present?
        name = params[:name]
      else
        name = sketch.file.to_s.split('/').last
      end

      sketch.update_attributes(:name => name)
      out = 'success'
    else
      out = 'fail'
    end
    
    render :partial => '/sketches/thumbnail', :locals => { :sketch => sketch }
  end

  # PATCH/PUT /sketches/1
  # PATCH/PUT /sketches/1.json
  def update
    if @sketch.update(sketch_params)
    else
    end
  end

  # DELETE /sketches/1
  # DELETE /sketches/1.json
  def destroy
    @sketch.destroy
    respond_to do |format|
      format.html { redirect_to sketches_url, notice: 'Sketch was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sketch
      @sketch = Sketch.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sketch_params
      params.fetch(:sketch, {})
    end
end
