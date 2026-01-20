class DestroyInformation < ActiveRecord::Migration[5.2]
  def change
    drop_table :information
  end
end
