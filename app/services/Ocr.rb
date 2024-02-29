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
        modified_text = annotation.description

        text += "#{modified_text.delete("・")}"
      end
    end
    text.delete!("\n").gsub!("原材料名", "")
    text.delete!("(国内製造)")
    text.delete!("こしょう/調味料無機塩等,")
    text.delete!(":").gsub!(" ", "、")
    text = text.split("、")
    text = text.uniq
    text = text.join(",")
    return text
  end
end
