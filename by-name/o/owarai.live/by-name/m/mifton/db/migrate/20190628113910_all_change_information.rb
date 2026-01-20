class AllChangeInformation < ActiveRecord::Migration[5.2]
  def change
    add_column :information, :user_id, :integer
    remove_column :information, :to_user_id
    remove_column :information, :from_user_id
  end
end
