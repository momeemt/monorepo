class ChangeAuthorityColumn < ActiveRecord::Migration[5.2]
  def change
    add_column :authorities, :manage_pos, :string, default: "general"
    add_column :authorities, :dev_pos, :string, default: "none"
    add_column :authorities, :donor_amount, :integer, default: 0
  end
end
