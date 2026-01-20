class CreateReports < ActiveRecord::Migration[5.2]
  def change
    create_table :reports do |t|
      t.integer :user_id
      t.integer :reported_object_id
      t.string :reported_object_type
      t.integer :report_reason
      t.timestamps
    end
  end
end
