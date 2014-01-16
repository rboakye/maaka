class ChangeLoginNameOfUsers < ActiveRecord::Migration
  def change
    remove_column :users, :login_name
    add_column :users, :user_name, :string
  end
end
