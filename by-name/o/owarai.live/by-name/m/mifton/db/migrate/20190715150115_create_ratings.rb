class CreateRatings < ActiveRecord::Migration[5.2]
  def change
    create_table :ratings do |t|
      t.integer :user_id
      t.integer :rate_value
      t.string :contest_type
      t.timestamps
    end
  end
end
