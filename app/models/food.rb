class Food < ApplicationRecord
  belongs_to :user

  has_many_attached :photos

  validates :ingredient_list, presence: true

end
