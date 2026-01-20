class CreateTopics < ActiveRecord::Migration[5.2]
  def change
    create_table :topics do |t|
      t.string :title
      t.text :content
      t.integer :user_id
      t.string :image_name
      t.timestamps
    end
  end
end
