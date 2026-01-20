class CreateNotificationColumn < ActiveRecord::Migration[5.2]
  def change
    create_table :notifications do |t|
      t.string :kind
      t.bigint :user_id
      t.string :target
      t.boolean :is_public
      t.integer :from_user
      t.string :from_service
      t.timestamps
    end
  end
end
