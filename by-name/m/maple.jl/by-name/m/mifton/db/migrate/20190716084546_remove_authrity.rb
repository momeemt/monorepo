class RemoveAuthrity < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :authority, :string
  end
end
