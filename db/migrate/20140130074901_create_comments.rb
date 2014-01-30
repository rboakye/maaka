class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :kasa_comment, null: false
      t.belongs_to :post
      t.timestamps
    end
    add_index :comments, [:post_id]
  end
end
