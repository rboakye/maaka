class AddFieldsToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :is_connected, :boolean, default: false
    add_column :posts, :connected_id, :integer
  end
end
