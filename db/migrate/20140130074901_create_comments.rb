class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :kasa_comment, null: false
      t.references :commentable, index: true, polymorphic: true, null: false
      t.string :user_uuid, null: false
      t.timestamps
    end
  end
end
