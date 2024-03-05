require "open-uri"
require "deepl"
require "json"

Favorite.destroy_all
Food.destroy_all
Ingredient.destroy_all

file = File.read('./ingredients.json')
ingredients = JSON.parse(file)

p ingredients

ingredients.each do |ingredient|
  Ingredient.create(ingredient)
end
