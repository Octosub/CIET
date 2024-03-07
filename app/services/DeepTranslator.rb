require 'deepl'

class DeepTranslator
  def self.translate_ingredients(ingredient_list)

    ingredient_list_array = ingredient_list.split(",")
    translated_ingredient_list = []

    ingredient_list_array.each do |ingredient|
      translated_ingredient = DeepL.translate "#{ingredient}", "JA", "EN"
      translated_ingredient_list << translated_ingredient
    end

    translated_ingredient_list = translated_ingredient_list.join(", ")

    return translated_ingredient_list
  end

  def self.translate_ingredient(ingredient)
    translation = DeepL.translate "#{ingredient}", "JA", "EN", context: "This Japanese ingredient in english is:"
    return translation.text
  end
end
