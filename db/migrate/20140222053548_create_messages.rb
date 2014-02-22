class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :message_type
      t.belongs_to :user, null: false
      t.string :sender_uuid, null: false
      t.string :transaction_id, null: false
      t.text :message_content, null: false
      t.string :status

      t.timestamps
    end
    add_index :messages, :user_id
  end
end
