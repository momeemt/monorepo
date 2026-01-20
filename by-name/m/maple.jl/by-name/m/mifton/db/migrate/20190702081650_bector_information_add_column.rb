class BectorInformationAddColumn < ActiveRecord::Migration[5.2]
  def change
    add_column :information, :starting_point_user, :integer
    add_column :information, :from_any_service, :string
    add_column :information, :target_object, :string

    remove_column :information, :info_type, :string
    remove_column :information, :info_target, :string
  end
end
