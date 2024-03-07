class User < ApplicationRecord
  has_many :favorites
  has_many :fav_foods, through: :favorites, source: :food

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :photo
  has_many :foods

  validates :preferences, presence: true
end
