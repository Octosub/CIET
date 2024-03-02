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
    prompt = <<~PROMPT
    "Classify the following list of ingredients into #{preference}, non-#{preference}, or can-be-#{preference} categories as accurately as possible. Please separate each ingredient with commas. Ignore words that do not make sense in an ingredients list. Here's an example: "Ingredient1, Ingredient2, Ingredient3." Respond as accurately as possible with one output for all products in the following format:
      {
        "#{preference}?": "false",  // always if at least one ingredient is non-#{preference}
        "#{preference}?": "can-be",  // only if no ingredient is non-#{preference}, with at least one can-be-#{preference} ingredient
        "#{preference}?": "true",  // only if all ingredients are #{preference}
        "false-flags": ["non-#{preference} ingredient1", "non-#{preference} ingredient2", ...],  // list of all but only non-#{preference} ingredients
        "can-be-flags": ["can-be ingredient1", "can-be ingredient2", ...],  // list of ingredients that can be #{preference}, depending on they way they are produced
        "true-flags": ["#{preference} ingredient1", "#{preference} ingredient2", ...]  // list of all #{preference} ingredients
      }
    Ingredients: #{self.ingredient_list.gsub("&#39;", "")}"
    PROMPT
    client = OpenAI::Client.new
    chaptgpt_response = client.chat(parameters: {
    model: "gpt-3.5-turbo",
    messages: [{ role: "user", content: prompt}],
    temperature: 0.0
    })
    JSON.parse(chaptgpt_response["choices"][0]["message"]["content"])
  end
end
