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


users = ['Koji', 'Felix', 'Leo', 'Noah']

users.each do |user_name|
  puts "creating #{user_name}"
  user = User.create(email: "#{user_name}@me.com", password: "123123")
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
    food.save
  end
end
