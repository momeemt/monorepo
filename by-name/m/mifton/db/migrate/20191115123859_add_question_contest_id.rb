class AddQuestionContestId < ActiveRecord::Migration[5.2]
  def change
    add_column :questions, :contest_id, :integer
  end
end
