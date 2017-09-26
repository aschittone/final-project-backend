class CreateListings < ActiveRecord::Migration[5.1]
  def change
    create_table :listings do |t|
      t.string :address
      t.integer :rent
      t.integer :taxes
      t.string :latitude
      t.string :longitude

      t.timestamps
    end
  end
end
