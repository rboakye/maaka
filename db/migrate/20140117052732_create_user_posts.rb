class CreateUserPosts < ActiveRecord::Migration
  def change
    create_table :user_posts do |t|
      t.references :user
      t.references :post
      t.timestamps
    end
      add_index :user_posts, ['user_id','post_id']
  end
end
