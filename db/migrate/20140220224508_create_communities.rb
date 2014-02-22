class CreateCommunities < ActiveRecord::Migration
  def change
    create_table :communities do |t|
      t.string :owner, null: false
      t.string :member_uuid, null: false
      t.boolean :family
      t.string :relationship
      t.timestamps
    end
  end
end
