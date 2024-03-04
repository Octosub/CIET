require 'json'

namespace :ingredients do
  desc "Create a json of our ingredients to seed from"
  task generate: :environment do
    # Your task logic here
  ingredients = Ingredient.all

  File.open('ingredients.json', 'w') do |f|
    f.write(ingredients.to_json)
  end
  end
end
