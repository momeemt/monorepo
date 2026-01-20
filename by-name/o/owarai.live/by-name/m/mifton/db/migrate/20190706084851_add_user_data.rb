class AddUserData < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :data_os, :string
    add_column :users, :data_sns, :string
    add_column :users, :data_where_know, :string
  end
end
