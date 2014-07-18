class AudioPiecesController < ApplicationController
  include UsersHelper
  include AudioPiecesHelper
  before_action :set_audio_piece, only: [:update, :destroy]



  # POST /audio_pieces
  def create
    @audio_piece = AudioPiece.new(audio_piece_params)
    @audio_piece.user_id = @current_user.user_uuid
    @audio_piece.audio_uuid = SecureRandom.uuid.to_s

    respond_to do |format|
      if @audio_piece.save
        @error = ''
        format.js
      else
        @error = 'could not create audio'
        format.js
      end
    end
  end

  # PATCH/PUT /audio_pieces/1
  def update
    respond_to do |format|
      if @audio_piece.update(audio_piece_params)
        @error = ''
        format.js
      else
        @error = 'could not update audio'
        format.js
      end
    end
  end

  # DELETE /audio_piece/1
  def destroy
    @audio_piece.destroy
    respond_to do |format|
      flash[:notice] = "Audio #{@audio_piece.audio_file_name} is deleted from Makasa"
      format.js
    end
  end

  private
  def set_audio_piece
    @audio_piece = AudioPiece.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def audio_piece_params
    params.require(:audio_piece).permit(:category, :audio)
  end
end
