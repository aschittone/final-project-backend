class CreateListings < ActiveRecord::Migration[5.1]
  def change
    create_table :listings do |t|
      t.string :number
      t.string :street
      t.string :town
      t.string :state
      t.string :zip_code

      t.timestamps
    end
  end
end
