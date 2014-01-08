class AddColumnToUsers < ActiveRecord::Migration
  def change
    add_column :users, :current_city, :string
    add_column :users, :phone, :string
    add_column :users, :gender, :string
    add_column :users, :about_me, :text
  end
end
