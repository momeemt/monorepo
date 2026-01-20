class ChangeInformationType < ActiveRecord::Migration[5.2]
  def change
    remove_column :information, :target_object, :string
    add_column :information, :target_object, :integer
  end
end
