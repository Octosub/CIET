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
  text = text.delete("\n").delete("\s").delete(":").delete("●")
  text = text.gsub("、 ", ",")
  text = text.gsub("、", ",")
  original = text.gsub("､", ",")
  remove_before = original.gsub(/(.*)?(原材料名)\s?(称?ポテトチップス称?)?/, "")
  remove_after = remove_before.gsub(/(\((一部に).*含む\).*)?(内容量.*)?/, "")
  text = remove_after.gsub(/(\((カナダ)?(国産)?又はアメリカ\))/, "")
  text = text.gsub(/(\/?調味料\(アミノ酸等)/, "")
  text = text.gsub(/(国内製造)/, "")
  text = text.gsub(/(酸化防止剤\(V.E\))/, "ビタミンE")
  text = text.gsub(/(酸化防止剤\(V.C\))/, "ビタミンC")
  text = text.gsub(/(国産米)/, "")
  text = text.gsub(/(\/?酢酸Na)/, "")
  text = text.gsub(/(pH調整剤,?)/, "")
  text = text.gsub(/(増粘剤\(.*\))/, "増粘剤")
  text = text.gsub(/(着色料\(.*\))/, "")
  # text = text.gsub(/(スープ)/, "")
  # text = text.gsub(/(\(分別生産流通管理済み\))/, "")
  # text = text.gsub(/(かやく)/, "")
  # text = text.gsub(/(着色料)/, "")
  # text = text.gsub(/(甘味料)/, "")
  # text = text.gsub(/(乳化剤)/, "")
  # text = text.gsub(/(輸入)/, "")
  # text = text.gsub(/(糖類)/, "")
  # text = text.gsub(/(\/糊料)/, "")
  # text = text.gsub(/(内容量:.*)/, "")
  # text = text.gsub(/(たん白加水分解物)/, "")
  # text = text.gsub(/(焙煎香辛料)/, "")
  # text = text.gsub(/(外国製造)/, "")
  text = text.delete(")").delete("(")
  text = text.gsub("・", ",")
  text = text.gsub("/", ",")
  text = text.split(",")
  text = text.uniq
  text = text.join(", ")
  return text
end
