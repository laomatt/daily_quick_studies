class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:welcome]
  # layout 'public', except: [:welcome]

  # GET /users
  # GET /users.json
  def index
    @users = User.paginate(:page => params[:page], :per_page => 8)
  end

  def welcome
    @page = 'welcome'
    if current_user
      redirect_to '/slideshows'
    end

    @pag_url = '/slideshows/reload_pag'
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @slideshows = Slideshow.all
  end

  def new_stuff
    @page = 'create'
  end

  def search
    users = User.where("lower(name) LIKE ?","%#{params[:phrase].downcase}%").first(8)
    render :partial => '/users/users_search_block', :locals => {:users => users}
  end

  def my_account
    @page = 'account'
    @pag_url = 'user'
  end

  def my_sketches
    @page = 'sketches'
    @sketches = current_user.sketches
  end


  def edit_slideshow_modal
    @slideshow = Slideshow.find(params[:id])
    render :partial => 'edit_slideshow', :locals => { :slideshow => @slideshow}
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name)
    end
end
