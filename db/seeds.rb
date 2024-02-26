require 'faker'

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require "open-uri"


Food.destroy_all
User.destroy_all

users = ['imnadleeh', 'flxlng', 'leamuno', 'Octosub']

users.each do |user_name|
  puts "creating #{user_name}"
  user = User.create(email: "#{user_name}@me.com", password: "123123")
  file = URI.open("https://kitt.lewagon.com/placeholder/users/#{user_name}")
  user.photo.attach(io: file, filename: "#{user_name}.jpg", content_type: "image/png")

  puts "creating dishes"

  2.times do
    ingredient_list = ''
    10.times do
      ingredient_list += "#{Faker::Food.ingredient}, "
    end
    ingredient_list += Faker::Food.ingredient
    dish = Faker::Food.dish
    puts user
    puts "creating #{dish}"
    food = Food.new(name: dish, ingredient_list: ingredient_list )
    food.user = user

    puts "attaching picture 1"
    file = URI.open('https://isitveganjapan.files.wordpress.com/2019/02/20190207_174944.jpg')
    food.photos.attach(io: file, filename: "onigiri_front.jpg", content_type: "image/png" )

    puts "attaching picture 2"
    file = URI.open('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTotMthTFHmevaDK1RGb4ZzSHr31MlDvKDIeg&s')
    food.photos.attach(io: file, filename: "onigiri_back.jpg", content_type: "image/png" )
    food.save
  end
end

10.times do
  Ingredient.create(:name Faker::Food.ingredient, vegetarian: true)
end

10.times do
  Ingredient.create(:name Faker::Food.ingredient, vegetarian: false)
end
