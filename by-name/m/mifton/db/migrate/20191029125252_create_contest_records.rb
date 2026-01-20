class CreateContestRecords < ActiveRecord::Migration[5.2]
  def change
    create_table :contest_records do |t|
      t.bigint :user_id
      t.integer :contest_id
      t.integer :q1_score
      t.integer :q1_elapsed_time
      t.integer :q2_score
      t.integer :q2_elapsed_time
      t.integer :q3_score
      t.integer :q3_elapsed_time
      t.integer :q4_score
      t.integer :q4_elapsed_time
      t.integer :primary_rating
      t.timestamps
    end
  end
end
