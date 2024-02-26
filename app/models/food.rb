class Food < ApplicationRecord
  belongs_to :user

  has_many_attached_photos :photos
end
