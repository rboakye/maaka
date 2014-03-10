class CreateTimelines < ActiveRecord::Migration
  def change
    create_table :timelines do |t|
      t.references :momentable, index: true, polymorphic: true, null: false
      t.references :user, null: false, index: true
      t.boolean :is_public, default: true
      t.timestamps
    end
  end
end
