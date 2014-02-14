class ImagesController < ApplicationController
  before_action :set_image, only: [:show, :edit, :update, :destroy]
  include UsersHelper

  # GET /images
  # GET /images.json
  def index
    @images = Image.all
  end

  # GET /images/1
  # GET /images/1.json
  def show
  end

  # GET /images/new
  def new
    @image = Image.new
  end

  # GET /images/1/edit
  def edit
  end

  # POST /images
  # POST /images.json
  def create
    @image = Image.new(image_params)
    @image.creator = @current_user.user_uuid
    @image.image_uuid = SecureRandom.uuid.to_s

    respond_to do |format|
      if @image.save
        UserImage.create(user_id: @current_user.id, image_id: @image.id, position: size = @current_user.images.size + 1)
        set_image_pos
        format.js
        format.json { render action: 'show', status: :created, location: @image }
      else
        format.js
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /images/1
  # PATCH/PUT /images/1.json
  def update
    respond_to do |format|
      if @image.update(image_params)
        format.html { redirect_to @image, notice: 'Image was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end

  #get /display_image
  def display_image
    @image = Image.find(params[:id])
    @user = User.find(params[:user])
    images_size = @user.images.count
    img = UserImage.where(user_id: @user.id, image_id: @image.id).first
    img_pos = img.position
    if img_pos
      if img_pos == images_size
        @previous_img_id = UserImage.where(user_id: @user.id, position: img_pos - 1).first.image_id
        @next_img_id = nil
      elsif img_pos == 1
        @next_img_id = UserImage.where(user_id: @user.id, position: img_pos + 1).first.image_id
        @previous_img_id = nil
      else
        @next_img_id = UserImage.where(user_id: @user.id, position: img_pos + 1).first.image_id
        @previous_img_id = UserImage.where(user_id: @user.id, position: img_pos - 1).first.image_id
      end
    else
      set_image_pos
    end
    @error = false
    respond_to do |format|
      if @image
        format.js
      else
        @error = true
        format.js
      end
    end
  end

  #get /display_other
  def display_other
    @image = Image.find(params[:id])
    @user = User.find(params[:user])
    images_size = @user.images.count
    img = UserImage.where(user_id: @user.id, image_id: @image.id).first
    img_pos = img.position
    if img_pos
      if img_pos == images_size
        @previous_img_id = UserImage.where(user_id: @user.id, position: img_pos - 1).first.image_id
        @next_img_id = nil
      elsif img_pos == 1
        @next_img_id = UserImage.where(user_id: @user.id, position: img_pos + 1).first.image_id
        @previous_img_id = nil
      else
        @next_img_id = UserImage.where(user_id: @user.id, position: img_pos + 1).first.image_id
        @previous_img_id = UserImage.where(user_id: @user.id, position: img_pos - 1).first.image_id
      end
    else
      set_image_pos
    end
    @error = false
    respond_to do |format|
      if @image
        format.js
      else
        @error = true
        format.js
      end
    end
  end

  # DELETE /images/1
  # DELETE /images/1.json
  def destroy
    @image.destroy
    set_image_pos
    respond_to do |format|
      format.js
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_image
      @image = Image.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def image_params
      params.require(:image).permit(:image_description, :creator, :image_uuid, :photo, :user)
    end

    def set_image_pos
      count = 1
      join_images = UserImage.where(:user_id => @current_user.id).order(:position)
      join_images.each do |img_join|
        img_join.position = count
        img_join.save!
        count += 1
      end
    end
end
