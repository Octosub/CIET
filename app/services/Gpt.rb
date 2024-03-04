class Gpt
  All_PREFERENCES = "vegan, vegetarian, pescetarian, peanut-free and dairy-free"

  def self.classify_ingredient(ingredient)
    prompt_vegan = "Is #{ingredient.name} vegan? Answer only 'true', 'false' or 'unclear'"
    vegan_response = gpt_call(prompt_vegan)
    if vegan_response.downcase.include?("true")
      ingredient.vegan = "true"
      ingredient.vegetarian = "true"
      ingredient.pescetarian = "true"
      ingredient.dairy_free = "true"
    else
      if vegan_response.downcase.include?("false")
        ingredient.vegan = "false"
      else
        ingredient.vegan = "can-be"
      end
      prompt_vegetarian = "Is #{ingredient.name} vegetarian? Answer only 'true', 'false' or 'unclear'"
      vegetarian_response = gpt_call(prompt_vegetarian)
      if vegetarian_response.downcase.include?("true")
        ingredient.vegetarian = "true"
        ingredient.pescetarian = "true"
      else
        if vegetarian_response.downcase.include?("false")
          ingredient.vegetarian = "false"
        else
          ingredient.vegetarian = "can-be"
        end
        prompt_pescetarian = "Is #{ingredient.name} pescetarian? Answer only 'true', 'false' or 'unclear'"
        pescetarian_response = gpt_call(prompt_pescetarian)
        if pescetarian_response.downcase.include?("true")
          ingredient.pescetarian = "true"
        elsif pescetarian_response.downcase.include?("false")
          ingredient.pescetarian = "false"
        else
          ingredient.pescetarian = "can-be"
        end
      end
      prompt_dairy_free = "Is #{ingredient.name} dairy-free? Answer only 'true', 'false' or 'unclear'"
      dairy_free_response = gpt_call(prompt_dairy_free)
      if dairy_free_response.downcase.include?("true")
        ingredient.dairy_free = "true"
      elsif dairy_free_response.downcase.include?("false")
        ingredient.dairy_free = "false"
      else
        ingredient.dairy_free = "can-be"
      end
    end
    prompt_peanut_free = "Is #{ingredient.name} peanut-free? Answer only 'true', 'false' or 'unclear'"
    peanut_free_response = gpt_call(prompt_peanut_free)
    if peanut_free_response.downcase.include?("true")
      ingredient.peanut_free = "true"
    elsif peanut_free_response.downcase.include?("false")
      ingredient.peanut_free = "false"
    else
      ingredient.peanut_free = "can-be"
    end
    ingredient.save
  end

  def self.describe_ingredient(ingredient)
    prompt = <<~PROMPT
    "Describe #{ingredient.name} in 1 sentence, how it is produced in 1 sentence whether that makes it #{All_PREFERENCES} in 1 short sentence."
    PROMPT
    client = OpenAI::Client.new
    chatgpt_response = client.chat(parameters: {
    model: "gpt-3.5-turbo",
    messages: [{ role: "user", content: prompt}],
    temperature: 0.0
    })
    chatgpt_response["choices"][0]["message"]["content"]
  end

  def self.classify_food_ingredient_list(food)
    # just here so it doesnt break
    preference = "vegan"
    prompt = <<~PROMPT
    "Classify the following list of ingredients into #{preference}, non-#{preference}, or can-be-#{preference} categories as accurately as possible: #{food.ingredient_list.gsub("&#39;", "")}
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

  def self.gpt_call(prompt)
    client = OpenAI::Client.new
    chatgpt_response = client.chat(parameters: {
    model: "gpt-3.5-turbo",
    messages: [{ role: "user", content: prompt}],
    temperature: 0.0
    })
    chatgpt_response["choices"][0]["message"]["content"]
  end
end
