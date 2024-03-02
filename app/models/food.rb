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
    gpt_response = vegan_api
    gpt_response["vegan?"]
  end

  def vegan_api
    preference = "vegan"
    client = OpenAI::Client.new
    chaptgpt_response = client.chat(parameters: {
    model: "gpt-3.5-turbo",
    messages: [{ role: "user", content: "Classify the following list of ingredients in #{preference}, non-#{preference}, or can-be-#{preference}. Every product must be in one of the categories. Respond with one output for all products in the following format:
      {\"#{preference}?\": \"true\" (if all ingredients are #{preference}), \"false\" (if at least one of the ingredients is non-#{preference}) or \"can-be\" (if all ingredients are #{preference} and at least one is can-be-#{preference}); \"false-flags\": all non-#{preference} ingredients; \"can-be-flags\": all can-be or unsure ingredients; \"true-flags\": all #{preference} ingredients}
      ingredients: #{self.ingredient_list.gsub("&#39;", "")}"}]
    })
    JSON.parse(chaptgpt_response["choices"][0]["message"]["content"])
  end
end
