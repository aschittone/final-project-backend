class CreateUserListings < ActiveRecord::Migration[5.1]
  def change
    create_table :user_listings do |t|
      t.integer :user_id
      t.integer :listing_id

      t.timestamps
    end
  end
end
