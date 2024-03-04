class Ingredient < ApplicationRecord

  validates :name, presence: true

  def classify_ingredient
    preferences = "vegan, vegetarian, pescetarian, peanut-free, dairy-free"
    prompt = <<~PROMPT
    "Classify #{self} into these dietary categories: #{preferences}
    Use the following format:
    {
    "preference1": "classification for preference1",
    "preference2": "classification for preference2",
    ...
    }
    "classification" should be "true" if #{self} corresponds to the preference, "false" if not, "can-be" if #{self} can be corresponsing to the preference or it's unclear.
    PROMPT
    client = OpenAI::Client.new
    chatgpt_response = client.chat(parameters: {
    model: "gpt-3.5-turbo",
    messages: [{ role: "user", content: prompt}],
    temperature: 0.0
    })
    JSON.parse(chatgpt_response["choices"][0]["message"]["content"].gsub("```json\n", "").gsub("\n```", ""))
  end

  def describe_ingredient
    prompt = <<~PROMPT
    "Briefly describe #{self} and how it is produced."
    PROMPT
    client = OpenAI::Client.new
    chatgpt_response = client.chat(parameters: {
    model: "gpt-3.5-turbo",
    messages: [{ role: "user", content: prompt}],
    temperature: 0.0
    })
    chatgpt_response["choices"][0]["message"]["content"]
  end
end
