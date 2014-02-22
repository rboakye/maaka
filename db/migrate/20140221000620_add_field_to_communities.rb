class AddFieldToCommunities < ActiveRecord::Migration
  def change
    add_column :communities, :member_uuid, :string, null: false
  end
end
