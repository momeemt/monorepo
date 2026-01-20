class AddDraftContestDuration < ActiveRecord::Migration[5.2]
  def change
    add_column :draft_contests, :duration, :integer
  end
end
