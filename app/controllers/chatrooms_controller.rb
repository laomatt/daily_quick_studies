class ChatroomsController < ApplicationController
  before_action :set_chatroom, only: [:show, :edit, :update, :destroy, :chat_popup]
  before_action :authenticate_user!
  # GET /chatrooms
  # GET /chatrooms.json
  def index
    @chatrooms = Chatroom.paginate(:page => params[:page], :per_page => 10)
    render :partial => 'chat_room_list', :locals => {:chatrooms => @chatrooms}
  end

  # GET /chatrooms/1
  # GET /chatrooms/1.json
  def show
    render :partial => 'chat_room_partial', :locals => {:chatroom => @chatroom}
  end

  # GET /chatrooms/new
  def new
    @chatroom = Chatroom.new
  end

  def get_user_sig
    message = Message.find(params[:mess][:id])
    render :partial => 'user_sig', :locals => {:mess => message, :display_pointer => params[:display_pointer], :connection_id => params[:connection_id] }
  end

  # GET /chatrooms/1/edit
  def edit
  end

  def chat_popup
    render :partial => 'chat_room_partial', :locals => {:chatroom => @chatroom}
  end

  def chat_room_search
    @chatrooms = Chatroom.where('lower(title) like ?', "%#{params[:search].downcase}%").paginate(:page => params[:page], :per_page => 10)
    render :partial => 'room_list', :locals => {:chatrooms => @chatrooms}
  end




  # DELETE /chatrooms/1
  # DELETE /chatrooms/1.json
  def destroy
    @chatroom.destroy
    respond_to do |format|
      format.html { redirect_to chatrooms_url, notice: 'Chatroom was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_chatroom
      @chatroom = Chatroom.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def chatroom_params
      params.permit(:room_id)
    end
end
