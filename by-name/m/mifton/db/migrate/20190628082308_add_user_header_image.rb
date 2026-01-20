class AddUserHeaderImage < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :header_image_name, :string, :default => "default_header.png"
  end
end
