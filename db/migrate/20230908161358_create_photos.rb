class CreatePhotos < ActiveRecord::Migration[7.0]
  def change
    create_table :photos do |t|
      t.integer :cemetery_id
      t.string :link
      t.string :thumb_link
      t.string :name
      t.string :year
      t.string :description
      t.string :coordinates

      t.timestamps
    end
  end
end
