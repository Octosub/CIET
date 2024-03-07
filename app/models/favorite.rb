class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :food

  validates :food, uniqueness: :true
end
