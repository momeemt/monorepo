class CreateReposts < ActiveRecord::Migration[5.2]
  def change
    create_table :reposts do |t|

      t.timestamps
    end
  end
end
