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
    if !gpt_response["false-flags"].empty?
      self.vegan = "false"
    elsif !gpt_response["can-be-flags"].empty?
      self.vegan = "can-be"
    else
      self.vegan = "true"
    end
  end

  def vegan_api
    preference = "vegan"
    prompt = <<~PROMPT
    "Classify the following list of ingredients into #{preference}, non-#{preference}, or can-be-#{preference} categories as accurately as possible: #{self.ingredient_list.gsub("&#39;", "")}
    Here's an example: "Ingredient1, Ingredient2, Ingredient3." Seperate or group the ingredients in a way that makes sense on an ingredients label. Ignore words that do not make sense on an ingredients label. Respond in one output for all products in the following format:
      {
        "false-flags": ["non-#{preference} ingredient1", "non-#{preference} ingredient2", ...],  // list of all and only non-#{preference} ingredients
        "true-flags": ["#{preference} ingredient1", "#{preference} ingredient2", ...]  // list of only but all #{preference} ingredients
        "can-be-flags": ["can-be-#{preference} ingredient1", "can-be-#{preference} ingredient2", ...],  // list of ingredients that not clearly #{preference} or non-#{preference}
      }"
    PROMPT
    client = OpenAI::Client.new
    chatgpt_response = client.chat(parameters: {
    model: "gpt-3.5-turbo",
    messages: [{ role: "user", content: prompt}],
    temperature: 0.0
    })
    JSON.parse(chatgpt_response["choices"][0]["message"]["content"].gsub("```json\n", "").gsub("\n```", ""))
  end
end
