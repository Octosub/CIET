class Ingredient < ApplicationRecord

  validates :name, presence: true
  validates :vegetarian, presence: true

end
