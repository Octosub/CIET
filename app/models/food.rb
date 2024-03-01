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

end
