class Ingredient < ApplicationRecord

  validates :name, presence: true, uniquness: true
  validates :vegetarian, presence: true

end
