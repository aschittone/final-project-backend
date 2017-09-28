class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :username
      t.string :password_digest
      t.string :average_annual_income, default: 0, null: false
      t.string :credit_score, default: 0, null: false
      t.string :assets, default: 0, null: false
      t.string :total_debt, default: 0, null: false

      t.timestamps
    end
  end
end
