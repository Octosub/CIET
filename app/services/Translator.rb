require "google/cloud/translate/v2"

class Translator
  def self.translation(ingredient_list)
    client = Google::Cloud::Translate::V2.new

    ingredient_list_array = ingredient_list.split(",")
    translated_ingredient_list = []

    ingredient_list_array.each do |ingredient|
      translated_ingredient = client.translate "#{ingredient}", to: "en"
      translated_ingredient_list << translated_ingredient
    end

    translated_ingredient_list = translated_ingredient_list.join(", ")

    return translated_ingredient_list
  end
end
