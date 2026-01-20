class CreateUserTraffics < ActiveRecord::Migration[5.2]
  def change
    create_table :user_traffics do |t|
      t.integer :user_id
      
      t.text :profile
      t.string :location
      t.string :user_link
      t.date :birthday

      t.string :platform # Minecraftのエディション
      t.string :twitter_id # Twitter ID
      t.string :lobi_id # Lobi ID
      t.string :github_id # Github ID
      t.string :discord_id # Discord ID

      t.integer :user_score, default: 0

      t.timestamps
    end
  end
end
