class AddInfotypeToInformation < ActiveRecord::Migration[5.2]
  def change
    add_column :information, :info_type, :string
    add_column :information, :info_target, :string
  end
end
