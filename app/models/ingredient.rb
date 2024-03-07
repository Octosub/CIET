class Ingredient < ApplicationRecord

  validates :name, presence: true

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

  def full_check(preferences)
    arr = []
    preferences.each do |preference|
      arr << self.check(preference)
    end
    return arr.uniq
  end
end
