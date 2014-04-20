class UsersController < ApplicationController
  before_action :set_user, only: [:update, :destroy]
  before_action :set_user_info, only: [:show, :edit]
  before_action :confirm_valid_session, :except => [:create, :password_request_update]
  before_action :session_active, :except => [:create, :password_request_update]
  include UsersHelper

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @can_view = in_my_community(@user,@current_user)
    if @can_view || @user.id == @current_user.id
      @kasas = @user.timelines.order('updated_at DESC').paginate(page: params[:page] || 1)

      @kasa = Post.new
      @comment = Comment.new
      @images = @user.images
      @can_view = true
      @community_list = @user.communities
      @messages = @user.messages
    end
    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /users/all_users.json
  def all_users
    @my_users = get_my_contacts(@current_user.communities)
    respond_to do |format|
        format.json
    end
  end

  # GET /users/all_users.json
  def alt_users
    @prefetch_ids = get_user_ids(@current_user.communities)
    @other_users = User.search_users(params[:search]).where.not(id: @prefetch_ids)
    respond_to do |format|
      format.json
    end
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    if @current_user.id == @user.id
      @my_kasas = @user.posts.order('created_at DESC')
      @image = Image.new
      @images = @user.images
      @messages = @user.messages
    elsif @user && in_my_community(@user,@current_user)
      redirect_to "/" + @user.user_name
    else
      redirect_to root_path
    end
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    @user.email = params[:user][:email].to_s.downcase.gsub(/\s+/,"")
    @user.user_uuid = SecureRandom.uuid.to_s
    @user.user_name = generate_user_name(@user)
    @user.phone = ''
    @error = false
    respond_to do |format|
      if @user.save
        session[:user_id] = @user.id
        UserMailer.welcome_email(@user).deliver
        UserSession.create(is_online: true, user_id: @user.id)
        flash[:notice] = "Thank you #{@user.first_name}, you have successfully created Makasa Account "
        @link = root_url
        format.js
        format.json { render action: 'index', status: :created, location: @user }
      else
        @error = true
        format.js
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    params[:user][:email] = params[:user][:email].to_s.downcase.gsub(/\s+/,"")
    params[:user][:user_name] = params[:user][:user_name].to_s.downcase.gsub(/\s+/,"")
    respond_to do |format|
      if @user.update(user_params)
        flash[:notice] = "#{@user.first_name}, you have successfully updated your Makasa Account "
        format.html { redirect_to "/" + @user.user_name + "/edit"}
        format.json { head :no_content }
      else
        flash[:error] = "#{@user.first_name}, there was a problem updating your Makasa Account - #{@user.errors.full_messages.to_sentence}"
        format.html { redirect_to "/" + @user.user_name + "/edit"}
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

  def password_request_update
    @user = User.find(params[:id])
    respond_to do |format|
      if @user.update(user_params)
        UserMailer.password_change_email(@user).deliver
        flash[:notice] = "#{@user.first_name}, you have successfully updated your password, please login"
        format.html { redirect_to root_path}
        format.json { head :no_content }
      else
        flash[:error] = "#{@user.first_name}, password update failed, wrong password combination"
        format.html { redirect_to root_path }
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

  # GET 'notify/:sender_id/request/:user_id'
  def connection_request
    @receiver = User.where(user_uuid: params[:user_id]).first
    @sender = User.where(user_uuid: params[:sender_id]).first
    @new_message = Message.new
    @new_message.message_type = 'connect'
    @new_message.user_id = @receiver.id
    @new_message.sender_uuid = @sender.user_uuid
    @new_message.transaction_id = gen_transaction_id
    @new_message.message_content = ''
    @new_message.status = 'respond'
    respond_to do |format|
      if @new_message.save!
        UserMailer.request_connect(@receiver,@sender).deliver
        flash[:notice] = "#{@sender.first_name}! your request has been sent to #{@receiver.first_name}, thank you"
        format.html { redirect_to "/#{User.find(@new_message.user_id).user_name}" }
      else
        flash[:error] = "Request Failed"
        format.html { redirect_to root_path }
      end
    end
  end

  # GET get 'users/connect/:response/:transaction_id'
  def connect_response
    if params[:response] == 'approve'
      @message = Message.where(transaction_id: params[:transaction_id]).first
      if @message
         @owner = User.find(@message.user_id)
         @sender = User.where(:user_uuid => @message.sender_uuid).first
       if @owner && @sender
         @community = Community.create(owner:@owner.user_uuid, member_uuid: @sender.user_uuid)
         @community_2 = Community.create(owner: @sender.user_uuid, member_uuid: @owner.user_uuid)
         if @community && @community_2
            UserCommunity.create(user_id: @owner.id, community_id: @community.id)
            UserCommunity.create(user_id: @sender.id, community_id: @community_2.id)
         end
       end
      end
    else
      @message = Message.where(transaction_id: params[:transaction_id]).first
      if @message
        @owner = User.find(@message.user_id)
      end
    end
    respond_to do |format|
      if @message
        @message.destroy
      end
      @messages = @owner.messages
      format.js
    end
  end

  # GET get 'users/connect_other/:response/:transaction_id'
  def connect_response_other
    if params[:response] == 'approve'
      @message = Message.where(transaction_id: params[:transaction_id]).first
      if @message
        @owner = User.find(@message.user_id)
        @sender = User.where(:user_uuid => @message.sender_uuid).first
        if @owner && @sender
          @community = Community.create(owner:@owner.user_uuid, member_uuid: @sender.user_uuid)
          @community_2 = Community.create(owner: @sender.user_uuid, member_uuid: @owner.user_uuid)
          if @community && @community_2
            UserCommunity.create(user_id: @owner.id, community_id: @community.id)
            UserCommunity.create(user_id: @sender.id, community_id: @community_2.id)
          end
        end
      end
    end
    respond_to do |format|
      if @message
        @message.destroy
      end
      flash[:notice] = "#{@owner.first_name}! is now connected with #{@sender.first_name}"
      format.html { redirect_to "/#{username_id_by_guid(@message.sender_uuid)}" }
    end
  end

  # GET get 'users/connect_other/:response/:transaction_id'
  def cancel_request
    @message = Message.where(transaction_id: params[:transaction_id]).first
    respond_to do |format|
      if @message
        @message.destroy
      end
      flash[:notice] = "Request to connect with #{User.find(@message.user_id).first_name} is cancel"
      format.html { redirect_to "/#{User.find(@message.user_id).user_name}" }
    end
  end

  # GET get 'users/update_messages'
  def update_messages
    @user = @current_user
    @messages = @current_user.messages
    respond_to do |format|
      format.js
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
    params.require(:user).permit(:first_name, :last_name, :email, :user_name, :user_uuid, :old_password, :password, :password_confirmation, :about_me, :phone, :current_city, :gender, :avatar, :birth_date, :transaction_id, :sender_id, :user_id, :response )
  end
end
