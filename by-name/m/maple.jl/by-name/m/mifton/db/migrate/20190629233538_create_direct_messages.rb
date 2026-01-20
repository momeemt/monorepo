class CreateDirectMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :direct_messages do |t|
      t.string :message
      t.integer :user_id
      t.string :target_user

      t.timestamps
    end
  end
end
