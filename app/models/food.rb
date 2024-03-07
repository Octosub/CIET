class Food < ApplicationRecord
  belongs_to :user
  has_many :favorites
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

  def update_flag(preference, flag)
    if preference == "vegan"
      self.vegan = flag
      self.save
    elsif preference == "vegetarian"
      self.vegetarian = flag
      self.save
    elsif preference == "pescetarian"
      self.pescetarian = flag
      self.save
    elsif preference == "dairy-free"
      self.dairy_free = flag
      self.save
    else
      self.peanut_free = flag
      self.save
    end
  end

  def check(preference)
    if preference == "vegan"
      return self.vegan
    elsif preference == "vegetarian"
      return self.vegetarian
    elsif preference == "pescetarian"
      return self.pescetarian
    elsif preference == "dairy-free"
      return self.dairy_free
    else
      return self.peanut_free
    end
  end

end
