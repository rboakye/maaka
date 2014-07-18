class CreateAudioPieces < ActiveRecord::Migration
  def change
    create_table :audio_pieces do |t|
      t.string :category
      t.string :audio_uuid, null: false
      t.references :user, null: false
      t.attachment :audio
      t.timestamps
    end
    add_index :audio_pieces, :user_id
    add_index :audio_pieces, :audio_uuid

  end
end
