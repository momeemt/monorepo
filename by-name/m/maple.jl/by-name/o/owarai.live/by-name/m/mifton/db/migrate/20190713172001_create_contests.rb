class CreateContests < ActiveRecord::Migration[5.2]
  def change
    create_table :contests do |t|

      t.string :name
      t.integer :times
      t.datetime :start_datetime
      t.integer :duration
      t.integer :rated_range
      t.integer :penalty
      t.string :contest_type

      t.boolean :is_public

      t.integer :question1_id
      t.integer :question2_id
      t.integer :question3_id
      t.integer :question4_id

      t.timestamps
    end
  end
end
