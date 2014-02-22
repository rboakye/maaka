class CreateUserCommunities < ActiveRecord::Migration
  def change
    create_table :user_communities do |t|
      t.references :user
      t.references :community
      t.timestamps
    end
    add_index :user_communities, ['user_id','community_id']
  end
end
