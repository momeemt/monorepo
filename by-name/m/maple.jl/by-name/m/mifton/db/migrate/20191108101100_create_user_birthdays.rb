class CreateUserBirthdays < ActiveRecord::Migration[5.2]
  def change
    create_table :user_birthdays do |t|
      t.bigint :user_id
      t.date :birthday
      t.string :publish_years, default: "publish"
      t.string :publish_date, default: "publish"
      t.timestamps
    end
  end
end
