class UsersController < ApplicationController
  before_action :set_user, only: [:update, :destroy]
  before_action :set_user_info, only: [:show, :edit]
  include UsersHelper

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @kasas = @user.posts
    @kasa = Post.new
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    @my_kasas = @user.posts
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    @user.user_uuid = SecureRandom.uuid.to_s
    @user.user_name = generate_user_name(@user)
    respond_to do |format|
      if @user.save
        session[:user_id] = @user.id
        UserMailer.welcome_email(@user).deliver
        flash[:notice] = "Thank you #{@user.first_name}, you have successfully created Makasa Account "
        format.html { redirect_to root_path }
        format.json { render action: 'index', status: :created, location: @user }
      else
        flash[:error] = "#{@user.first_name}, there were issues creating your Makasa Account. Please fix form errors and try again "
        format.html { render action: 'index' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        flash[:notice] = "#{@user.first_name}, you have successfully updated your Makasa Account "
        format.html { redirect_to "/" + @user.user_name + "/edit"}
        format.json { head :no_content }
      else
        flash[:notice] = "#{@user.first_name}, there was a problem updating your Makasa Account "
        format.html { render action: 'show' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end


 def avatar_update
      @user = User.find(params[:id])
      has_image = true
      if params[:user] == nil
        has_image = false
      end
      respond_to do |format|
        if has_image
          if @user.update(user_params)
            flash[:notice] = "#{@user.first_name}, you have successfully updated your Profile Picture "
          else
            flash[:error] = "#{@user.first_name}, photo update fails"
          end
          format.html { redirect_to "/" + @user.user_name + "/edit"}
          format.json { head :no_content }
        else
          flash[:error] = "#{@user.first_name}, please choose a file to upload"
          format.html { redirect_to "/" + @user.user_name + "/edit" }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
    end
 end

  def password_update
    @user = User.find(params[:id])
    authorized_user = @user.authenticate(params[:old_password])
    respond_to do |format|
      if authorized_user && pass_help
        if @user.update(user_params)
          UserMailer.password_change_email(@user).deliver
          flash[:notice] = "#{@user.first_name}, you have successfully updated your password"
        else
          flash[:error] = "#{@user.first_name}, password update fails, wrong password combinations"
        end
        format.html { redirect_to "/" + @user.user_name + "/edit"}
        format.json { head :no_content }
      else
        flash[:error] = "#{@user.first_name}, password update failed, wrong password combination"
        format.html { redirect_to "/" + @user.user_name + "/edit?password=failed" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      flash[:notice] = "User #{@user.first_name} is deleted from Makasa"
      format.html { redirect_to root_path }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  def set_user_info
    @user = User.where(:user_name => params[:username]).first
  end

  def pass_help
    if params[:user][:password] != "" && params[:user][:password_confirmation] != "" && params[:user][:password] == params[:user][:password_confirmation] && params[:user][:password].size >= 6
      return true
    else
      return false
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :user_name, :user_uuid, :old_password, :password, :password_confirmation, :about_me, :phone, :current_city, :gender, :avatar, :birth_date)
  end
end
