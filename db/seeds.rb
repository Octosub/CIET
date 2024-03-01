require "faker"
require "open-uri"

Food.destroy_all
User.destroy_all
Ingredient.destroy_all
users = ["imnadleeh", "flxlng", "leamuno", "Octosub"]
users.each do |user_name|
  puts "creating #{user_name}"
  user = User.create(email: "#{user_name}@me.com", password: "123123")
  file = URI.open("https://kitt.lewagon.com/placeholder/users/#{user_name}")
  user.photo.attach(io: file, filename: "#{user_name}.jpg", content_type: "image/png")
  puts "creating dishes"
  2.times do
    ingredient_list = ""
    9.times do
      ingredient_list += "#{Faker::Food.ingredient}, "
    end
    ingredient_list += Faker::Food.ingredient
    dish = Faker::Food.dish
    puts "creating #{dish}"
    food = Food.new(name: dish, ingredient_list: ingredient_list, vegan: true)
    food.user = user
    puts "attaching picture 1"
    file = URI.open("https://isitveganjapan.files.wordpress.com/2019/02/20190207_174944.jpg")
    food.photos.attach(io: file, filename: "onigiri_front.jpg", content_type: "image/png" )
    puts "attaching picture 2"
    file = URI.open("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTotMthTFHmevaDK1RGb4ZzSHr31MlDvKDIeg&s")
    food.photos.attach(io: file, filename: "onigiri_back.jpg", content_type: "image/png" )
    food.save
  end
end
