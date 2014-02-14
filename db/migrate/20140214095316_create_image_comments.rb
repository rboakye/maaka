class CreateImageComments < ActiveRecord::Migration
  def change
    create_table :image_comments do |t|
      t.references :image
      t.references :comment
      t.timestamps
    end
    add_index :image_comments, ['comment_id','image_id']

  end
end
