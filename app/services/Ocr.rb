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
      text = res.text_annotations[0].description
    end

    return cleanup(text)
  end
end

private

def cleanup(text)
  text = text.delete("\n")
  text = text.gsub(/(一部に).*含む\)?$/, "")
  text = text.delete("(")
  text = text.delete(")")
  text = text.delete("等")
  text = text.delete("調味料")
  text = text.delete(":")
  text = text.delete("国内製造")
  text = text.delete("原材料名")
  text = text.gsub("、 ", ",")
  text = text.gsub("、", ",")
  text = text.gsub("・", ",")
  text = text.gsub("/", ",")
  text = text.gsub("､", ",")
  text = text.gsub(" ", ",")
  text = text.gsub(",,", ",")
  text[-1] = ""
  return text
end
