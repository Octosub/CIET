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
    require "./app/services/Translator.rb"

    translated_ingredient_list = DeepTranslator.translate_ingredients(self.ingredient_list)
    self.ingredient_list = translated_ingredient_list
    save
  end

  def vegan_boolean
    # needs change, just here so it doesnt break
    gpt_response = Gpt.classify_food_ingredient_list(self)
    if !gpt_response["false-flags"].empty?
      self.vegan = "false"
    elsif !gpt_response["can-be-flags"].empty?
      self.vegan = "can-be"
    else
      self.vegan = "true"
    end
    self.save
  end

  def classify_ingredients_individually
    @true_vegan_flags = []
    @can_be_vegan_flags = []
    @false_vegan_flags = []
    self.ingredient_list.split(", ").each do |ingredient|
      ing = Ingredient.find_by(english_name: ingredient)
      if ing.vegan == "true"
        @true_vegan_flags << ing
      elsif ing.vegan == "false"
        @false_vegan_flags << ing
      else
        @can_be_vegan_flags << ing
      end
    end
  end
  
end
