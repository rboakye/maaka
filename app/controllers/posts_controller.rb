class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  include PostsHelper
  include UsersHelper

  # GET /posts
  # GET /posts.json
  def index
    @posts = Timeline.where(is_public: true).order('updated_at DESC')
    @user = User.new
    @comment = Comment.new
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json
  def create
    @comment = Comment.new
    @user = @current_user
    @post = Post.new(post_params)
    @post.post_uuid = SecureRandom.uuid.to_s
    respond_to do |format|
      if @post.save
        create_join(@post.id, @user_id)
        @post.timelines.create(user_id: @user.id, is_public:true)
       # flash[:notice] = "#{@user_fullname}, your new kasa was successful"
        format.js
        format.json { render action: 'show', status: :created, location: @post }
      else
        flash[:error] = "#{@user.first_name}, creating new kasa failed "
        format.js
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /posts
  # POST /posts.json
  def connected_post
    @comment = Comment.new
    @user = @current_user
    @post = Post.new(post_params)
    @post.post_uuid = SecureRandom.uuid.to_s
    @post.is_connected = true
    @post.connected_id = params[:connected_id]
    @con_user = User.find(@post.connected_id)
    @current_user = User.find(@user_id)
    con_user_session = @con_user.user_session
    respond_to do |format|
      if @post.save
        create_connected_join(@post.id, params[:connected_id])
        @post.timelines.create(user_id: @user.id, is_public:true)
        #  flash[:notice] = "#{@user_fullname}, your new kasa was successful"
        if con_user_session.is_online == false
          UserMailer.user_notification(@current_user,@con_user).deliver
        end
        format.js
        format.json { render action: 'show', status: :created, location: @post }
      else
        flash[:error] = "#{@user.first_name}, creating new kasa failed "
        format.js
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  #get /posts/delete_modal/uuid
  def delete_modal
    @post = Post.where(post_uuid: params[:post_uuid]).first
    respond_to do |format|
      if @post
        format.js
      else
        format.js
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.js
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      if params[:id]
        @post = Post.find(params[:id])
      end
    end


    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:post_by, :post_content, :is_private, :post_uuid, :connected_id, :post_uuid)
    end
end
