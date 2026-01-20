class CreateContestJoinUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :contest_join_users do |t|

      t.integer :user_id
      t.integer :contest_id

      t.timestamps
    end
  end
end
