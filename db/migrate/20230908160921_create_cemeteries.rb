class CreateCemeteries < ActiveRecord::Migration[7.0]
  def change
    create_table :cemeteries do |t|
      t.string :name
      t.string :year_opened
      t.string :year_closed
      t.string :description
      t.string :coordinates

      t.timestamps
    end
  end
end
