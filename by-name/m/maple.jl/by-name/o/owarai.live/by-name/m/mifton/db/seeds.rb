# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


# User.create!(name:  "Example User",
#              email: "example@railstutorial.org",
#              password:              "foobar",
#              password_confirmation: "foobar")
#
# 99.times do |n|
#   name  = Faker::Name.name
#   email = "example-#{n+1}@railstutorial.org"
#   password = "password"
#   User.create!(name:  name,
#                email: email,
#                password:              password,
#                password_confirmation: password)
# end
#
# users = User.order(:created_at).take(5)
# 50.times do
#   content = Faker::Lorem.sentence(50)
#   User.find_by(id: 1).microposts.create!(content: content)
# end

user = User.create(
  name: "Mifton Official",
  email: "mifton@mifton.xyz",
  password: "password",
  password_confirmation: "password",
  user_id: "mifton"
)

authority = user.build_authority(
  manage_pos: "admin"
)

authority.save

user_data = user.build_user_traffic

user_data.save
