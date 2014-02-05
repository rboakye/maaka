class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.text :image_description
      t.string :creator
      t.string :image_uuid
      t.timestamps
    end
  end
end
