class Food < ApplicationRecord
  belongs_to :user
  has_many_attached :photos

  # validates :ingredient_list, presence: true
  # validates :photos, presence: true
  before_save :translate


  def translate
    require "google/cloud/translate/v2"
    gtranslate_client = Google::Cloud::Translate::V2.new(
      project_id: "INSERT PROJECT ID",
      credentials: "INSERT CREDENTIAL FILE PATH"
     )
    puts "translating..."

    translation = gtranslate_client.translate "#{ingredient_list}", to: "en"
    self.ingredient_list = translation
    puts "translation successfull, saving..."
  end
end
