class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.text :content
      t.bigint :user_id
      t.string :image_name
      t.string :parent_model
      t.bigint :parent_id
      t.timestamps
    end
  end
end
