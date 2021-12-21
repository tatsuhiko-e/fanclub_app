# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?

5.times do |n|
  user = User.create(
    email: "test#{n + 1}@test.com",
    name: "テスト#{n + 1}",
    password: 'password',
    password_confirmation: 'password',
    confirmed_at: Date.today ,
    area: 1 ,
    gender: 0 ,
    profile: 'aaaaaaaaaaaaa',
    theme: 1 ,
    admin: true
  )
  user.image.attach(io: File.open(Rails.root.join("app/assets/images/0#{n + 1}.jpg")),
                  filename: "0#{n + 1}.jpg")
end
