class CreateDraftContests < ActiveRecord::Migration[5.2]
  def change
    create_table :draft_contests do |t|
      t.string :name
      t.integer :times
      t.datetime :start_datetime
      t.integer :rated_range
      t.integer :penalty
      t.string :contest_type
      t.timestamps
    end
  end
end
