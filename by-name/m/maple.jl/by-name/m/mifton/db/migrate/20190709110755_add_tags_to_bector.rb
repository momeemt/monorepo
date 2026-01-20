class AddTagsToBector < ActiveRecord::Migration[5.2]
  def change
    add_column :microposts, :tags, :string
  end
end
