class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :food

  validates :food, uniqueness: :true

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
