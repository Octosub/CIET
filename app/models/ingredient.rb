class Ingredient < ApplicationRecord

  validates :name, presence: true

  def check(preference)
    if preference == "vegan"
      return self.vegan
    elsif preference == "vegitarian"
      return self.vegitarian
    elsif preference == "pescitarian"
      return self.pescitarian
    elsif preference == "dairy-free"
      return self.dairy_free
    else
      return self.peanut_free
    end
  end
end
