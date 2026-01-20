class AddImageToMicroposts < ActiveRecord::Migration[5.2]
  def change
    add_column :microposts, :image_name, :string
  end
end
