class CreateInformation < ActiveRecord::Migration[5.2]
  def change

    add_column :information, :to_user_id, :string
    add_column :information, :from_user_id, :string

    remove_column :information, :name
    remove_column :information, :author
  end
end
