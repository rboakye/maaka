class AddFieldsToComments < ActiveRecord::Migration
  def change
    add_column :comments, :user_uuid, :string, null: false
  end
end
