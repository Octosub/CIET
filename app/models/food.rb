class Food < ApplicationRecord
  belongs_to :user
  has_many_attached :photos

  # validates :ingredient_list, presence: true
  # validates :photos, presence: true
  # after_save :extract_ingredients, :translate

  def extract_ingredients
    require "./app/services/Ocr.rb"
    extracted_text = Ocr.extract_text(self.photos[0])
    formatted_text = extracted_text
    self.ingredient_list = formatted_text
    save
  end

  def translate
    gtranslate_client = Google::Cloud::Translate::V2.new
    puts "translating..."
    ingredient_list_array = self.ingredient_list.split(",")
    translated_ingredient_list = []

    ingredient_list_array.each do |ingredient|
      translated_ingredient = gtranslate_client.translate "#{ingredient}", to: "en"
      translated_ingredient_list << translated_ingredient
    end

    translated_ingredient_list = translated_ingredient_list.join(", ")

    self.ingredient_list = translated_ingredient_list
    puts "translation successfull, saving..."
    save
  end

  def vegan_boolean
    ingredients = vegan_api
    ingredients["isVeganSafe"]
  end

  # def true_vegan_flags
  # end

  # def can_be_vegan_flags
  # end

  def non_vegan_flags
    ingredients = vegan_api
    if self.ingredient_list.split(',').length > 1
      return ingredients["isVeganResult"]["nonvegan"]
    else
      return []
    end
  end

  # def vegetarian_boolean
  # end

  # def true_vegetarian_flags
  # end

  # def can_be_vegetarian_flags
  # end

  # def non_vegetarian_flags
  # end

private

  def vegan_api
    ingredients = self.ingredient_list.gsub("&#39;", "")
    url = "https://is-vegan.netlify.app/.netlify/functions/api?ingredients=#{I18n.transliterate(ingredients)}"
    ingredients_serialized = HTTParty.get(url).body
    JSON.parse(ingredients_serialized)
  end
end
