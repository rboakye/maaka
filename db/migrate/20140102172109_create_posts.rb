class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :post_by, null: false
      t.text :post_content, null: false
      t.boolean :is_private, null:false, default: false
      t.string :post_uuid, null:false

      t.timestamps
    end
  end
end
