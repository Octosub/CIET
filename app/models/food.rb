class Food < ApplicationRecord
  belongs_to :user

  has_many_attached :photos

  validates :name, presence: true
  validates :ingredient_list, presence: true

end
