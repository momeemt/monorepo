class CreateReactions < ActiveRecord::Migration[5.2]
  def change
    create_table :reactions do |t|
      t.integer :user_id
      t.integer :reactioned_id
      t.string :reactioned_type

      t.timestamps
    end
  end
end
