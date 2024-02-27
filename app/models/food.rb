require "google/cloud/translate"

class Food < ApplicationRecord

  belongs_to :user
  has_many_attached :photos

  # validates :ingredient_list, presence: true
  validates :photos, presence: true
  before_save :translate


  def translate
    gtranslate_client = Google::Cloud::Translate.translation_v2_service( credentials: "grounded-elf-415603-0893a7160822.json")

    translation = gtranslate_client.translate "#{ingredient_list}", to: "jp"
    self.ingredient_list = translation
    save
  end

end
