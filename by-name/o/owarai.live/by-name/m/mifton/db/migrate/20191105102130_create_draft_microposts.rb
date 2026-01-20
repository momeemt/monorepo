class CreateDraftMicroposts < ActiveRecord::Migration[5.2]
  def change
    create_table :draft_microposts do |t|
      t.text "content"
      t.bigint "user_id"
      t.timestamps
    end
  end
end
