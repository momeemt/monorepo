class ChangeNameIdenfId < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :idenf_id, :string
    add_column :users, :user_id, :string
  end
end
