# app/services/Ocr.rb
require 'open-uri'
require "google/cloud/vision"

class Ocr
  def self.extract_text(image_file)
    Google::Cloud::Vision.configure do |config|
      config.credentials = JSON.parse(ENV.fetch('VISION_CREDENTIALS'))
    end
    client = Google::Cloud::Vision.image_annotator

    data = client.text_detection(image: image_file)
    # TODO: extract string from data
    text = ""
    data.responses.each do |res|
      res.text_annotations.each do |annotation|
        text << annotation.description
      end
    end
  end
end
