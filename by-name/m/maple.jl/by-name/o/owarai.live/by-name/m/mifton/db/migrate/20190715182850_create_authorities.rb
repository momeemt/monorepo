class CreateAuthorities < ActiveRecord::Migration[5.2]
  def change
    create_table :authorities do |t|
      t.integer :user_id
      t.boolean :chief_administrator, default: false
      t.boolean :administrator, default: false
      t.boolean :trust_user, default: false
      t.boolean :developer, default: false
      t.boolean :donor, default: false
      t.boolean :official_writer, default: false
      t.boolean :general, default: true 
      t.timestamps
    end
  end
end
