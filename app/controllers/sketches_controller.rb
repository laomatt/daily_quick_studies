class SketchesController < ApplicationController
  layout false
  # before_action :set_sketch, only: [:show, :edit, :update, :destroy]
  # skip

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

  def get_sketches_for_slide
    sketches = Slide.find(params[:slide_id]).sketches
    render :partial => '/sketches/sketches_collection', :locals => { :sketches => sketches }
  end

  def get_sketch_image
    sketch = Sketch.find(params[:sketch_id])
    url = sketch.file.url
    name = sketch.name

    render :json => { :url => url, :name => name }
  end

  def get_upload_form_for_slide
    slide = Slide.find(params[:slide_id])

    render :partial => '/sketches/upload_form', :locals => { :slide => slide }
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
      # @sketch = Sketch.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    # def sketch_params
    #   params.fetch(:sketch, {})
    # end
end
