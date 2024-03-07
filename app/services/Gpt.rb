class Gpt
  ALL_PREFERENCES = ["vegan", "vegetarian", "pescetarian", "peanut-free", "dairy-free"]

  def self.classify_ingredient(ingredient)
    prompt_vegan = "Is #{ingredient.english_name} vegan? Answer only 'true', 'false' or 'unclear'"
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
      prompt_vegetarian = "Is #{ingredient.english_name} vegetarian? Answer only 'true', 'false' or 'unclear'"
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
        prompt_pescetarian = "Is #{ingredient.english_name} pescetarian? Answer only 'true', 'false' or 'unclear'"
        pescetarian_response = gpt_call(prompt_pescetarian)
        if pescetarian_response.downcase.include?("true")
          ingredient.pescetarian = "true"
        elsif pescetarian_response.downcase.include?("false")
          ingredient.pescetarian = "false"
        else
          ingredient.pescetarian = "can-be"
        end
      end
      prompt_dairy_free = "Is #{ingredient.english_name} dairy-free? Answer only 'true', 'false' or 'unclear'"
      dairy_free_response = gpt_call(prompt_dairy_free)
      if dairy_free_response.downcase.include?("true")
        ingredient.dairy_free = "true"
      elsif dairy_free_response.downcase.include?("false")
        ingredient.dairy_free = "false"
      else
        ingredient.dairy_free = "can-be"
      end
    end
    prompt_peanut_free = "Is #{ingredient.english_name} peanut-free? Answer only 'true', 'false' or 'unclear'"
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
    prompt_pref = []
    ALL_PREFERENCES.each do |preference|
      if (ingredient.check(preference) != "true")
        prompt_pref << preference
      end
    end
    prompt = ""
    if (prompt_pref.count > 1)
      prompt_pref[-1] = "and #{preferences[-1]}"
      prompt_pref = prompt_pref.join(", ")
      prompt = <<~PROMPT
      "Create a short 1 to 2 sentence description about how #{ingredient.english_name} is produced, and how that potentially makes it not #{prompt_pref}."
      PROMPT
    elsif (prompt_pref.count == 1)
      prompt_pref = prompt_pref.join
      prompt = <<~PROMPT
      "Create a short 1 to 2 sentence description about how #{ingredient.english_name} is produced, and how that potentially makes it not #{prompt_pref}."
      PROMPT
    else
      prompt = <<~PROMPT
      "Create a short 1 to 2 sentence description about how #{ingredient.english_name} is produced."
      PROMPT
    end
    client = OpenAI::Client.new
    chatgpt_response = client.chat(parameters: {
    model: "gpt-3.5-turbo",
    messages: [{ role: "user", content: prompt}],
    temperature: 0.0
    })
    response = chatgpt_response["choices"][0]["message"]["content"]
    ingredient.english_description = response
    ingredient.save
  end

  def self.describe_unknown_ingredient(ingredient)
    prompt_pref = ALL_PREFERENCES
    prompt = ""
    if (prompt_pref.count > 1)
      prompt_pref[-1] = "and #{prompt_pref[-1]}"
      prompt_pref = prompt_pref.join(", ")
      prompt = <<~PROMPT
      "Create a short 1 to 2 sentence description about how #{ingredient.text} is produced, and how that potentially makes it not #{prompt_pref}."
      PROMPT
    elsif (prompt_pref.count == 1)
      prompt_pref = prompt_pref.join
      prompt = <<~PROMPT
      "Create a short 1 to 2 sentence description about how #{ingredient.text} is produced, and how that potentially makes it not #{prompt_pref}."
      PROMPT
    else
      prompt = <<~PROMPT
      "Create a short 1 to 2 sentence description about how #{ingredient.text} is produced."
      PROMPT
    end
    client = OpenAI::Client.new
    chatgpt_response = client.chat(parameters: {
    model: "gpt-3.5-turbo",
    messages: [{ role: "user", content: prompt}],
    temperature: 0.0
    })
    chatgpt_response["choices"][0]["message"]["content"]
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
