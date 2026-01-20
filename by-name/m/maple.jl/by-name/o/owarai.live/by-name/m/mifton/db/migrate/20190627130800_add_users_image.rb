class AddUsersImage < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :image_name, :string, :default => "default_icon.png"
  end
end
