class DropTableDraftContest < ActiveRecord::Migration[5.2]
  def change
    drop_table :draft_contests
  end
end
