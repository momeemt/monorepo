class RemoveContestColumn < ActiveRecord::Migration[5.2]
  def change
    remove_column :contests, :question1_id, :integer
    remove_column :contests, :question2_id, :integer
    remove_column :contests, :question3_id, :integer
    remove_column :contests, :question4_id, :integer
    remove_column :contests, :is_public, :boolean
    remove_column :contest_records, :q1_score, :integer
    remove_column :contest_records, :q1_elapsed_time, :integer
    remove_column :contest_records, :q2_score, :integer
    remove_column :contest_records, :q2_elapsed_time, :integer
    remove_column :contest_records, :q3_score, :integer
    remove_column :contest_records, :q3_elapsed_time, :integer
    remove_column :contest_records, :q4_score, :integer
    remove_column :contest_records, :q4_elapsed_time, :integer
  end
end
