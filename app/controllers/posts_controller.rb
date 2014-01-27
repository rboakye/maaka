class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  include PostsHelper
  include UsersHelper

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all
    @user = User.new
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
    @post = Post.new(post_params)
    @post.post_uuid = SecureRandom.uuid.to_s
    respond_to do |format|
      if @post.save
        create_join(@post.id, @user_id)
       # flash[:notice] = "#{@user_fullname}, your new kasa was successful"
        format.html { redirect_to "/#{user_by_guid(@post.post_by).user_name}" }
        format.json { render action: 'show', status: :created, location: @post }
      else
        flash[:error] = "#{@user.first_name}, creating new kasa failed "
        format.html { redirect_to controller: 'posts', action: 'index'}
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /posts
  # POST /posts.json
  def connected_post
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
      #  flash[:notice] = "#{@user_fullname}, your new kasa was successful"
        if con_user_session.is_online == false
          UserMailer.user_notification(@current_user,@con_user).deliver
        end
        format.html { redirect_to "/#{@con_user.user_name}" }
        format.json { render action: 'show', status: :created, location: @post }
      else
        flash[:error] = "#{@user.first_name}, creating new kasa failed "
        format.html { redirect_to controller: 'posts', action: 'index'}
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

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url }
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
      params.require(:post).permit(:post_by, :post_content, :is_private, :post_uuid, :connected_id)
    end
end
