# app/services/Ocr.rb
require 'open-uri'
require "google/cloud/vision"

class Ocr
  def self.extract_text(image_file)
    client = Google::Cloud::Vision.image_annotator

    data = client.text_detection(image: image_file.url)
    # TODO: extract string from data
    text = ""

    data.responses.each do |res|
      res.text_annotations.each do |annotation|
        text += "#{annotation.description}"
      end
    end
    return text
  end
end
