class CreateUserSessions < ActiveRecord::Migration
  def change
    create_table :user_sessions do |t|
      t.boolean :is_online, default: false
      t.datetime :last_seen
      t.belongs_to :user
      t.timestamps
    end
    add_index :user_sessions, [:user_id]
  end
end
