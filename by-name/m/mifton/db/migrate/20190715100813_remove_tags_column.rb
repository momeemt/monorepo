class RemoveTagsColumn < ActiveRecord::Migration[5.2]
  def change
    remove_column :microposts, :tags, :string
  end
end
