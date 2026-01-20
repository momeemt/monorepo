class DropTableContest < ActiveRecord::Migration[5.2]
  def change
    drop_table :contests
  end
end
