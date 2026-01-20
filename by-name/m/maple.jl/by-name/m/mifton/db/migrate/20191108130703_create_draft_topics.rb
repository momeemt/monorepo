class CreateDraftTopics < ActiveRecord::Migration[5.2]
  def change
    create_table :draft_topics do |t|
      t.string :title
      t.text :content
      t.integer :user_id
      t.timestamps
    end
  end
end
