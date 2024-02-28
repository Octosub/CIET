class Food < ApplicationRecord
  belongs_to :user
  has_many_attached :photos

  # validates :ingredient_list, presence: true
  # validates :photos, presence: true
  before_save :extract_ingredients, :translate

  def extract_ingredients
    require "./app/services/Ocr.rb"
    extracted_text = Ocr.extract_text(self.photos[0])
    formatted_text = extracted_text
    self.ingredient_list = formatted_text

  end

  def translate
    require "google/cloud/translate/v2"
    gtranslate_client = Google::Cloud::Translate::V2.new(
      project_id: "grounded-elf-415603",
      credentials: "./grounded-elf-415603-0893a7160822.json"
     )
    puts "translating..."

    translation = gtranslate_client.translate "#{ingredient_list}", to: "en"
    self.ingredient_list = translation
    puts "translation successfull, saving..."
  end

end
