class CommentsController < ApplicationController
  before_action :set_comment, only: [:show, :edit, :update, :destroy]
  include CommentsHelper
  include UsersHelper


  # GET /comments
  # GET /comments.json
  def index
    @comments = Comment.all
  end

  # GET /comments/1
  # GET /comments/1.json
  def show
  end

  # GET /comments/new
  def new
    @comment = Comment.new
  end

  # GET /comments/1/edit
  def edit
  end

  # POST /comments
  # POST /comments.json
  def create
    @user = @current_user
    @post = Post.find(params[:comment][:post_id])
    @comment = @post.comments.create(kasa_comment: params[:comment][:kasa_comment], user_uuid: @current_user.user_uuid)
    respond_to do |format|
      if @comment
        format.js
        format.json { render action: 'show', status: :created, location: @comment }
      else
        format.js
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /image_comment
  def image_comment
    @user = @current_user
    @image = Image.find(params[:comment][:image_id])
    @comment = @image.comments.create(kasa_comment: params[:comment][:kasa_comment], user_uuid: @current_user.user_uuid)
    respond_to do |format|
      if @comment
        format.js
      else
        format.js
      end
    end
  end

  # PATCH/PUT /comments/1
  # PATCH/PUT /comments/1.json
  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to @comment, notice: 'Comment was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @comment.destroy
    respond_to do |format|
      format.js
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.require(:comment).permit(:kasa_comment, :post_id, :image_id)
    end
end
