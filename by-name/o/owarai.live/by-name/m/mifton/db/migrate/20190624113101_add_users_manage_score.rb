class AddUsersManageScore < ActiveRecord::Migration[5.2]
  def up
    add_column :users, :idenf_id, :string
    add_column :users, :reported_value, :integer, default: 0
    add_column :users, :trusted_value, :integer, default: 0
    add_column :users, :is_test_user, :boolean, default: false
  end
end
