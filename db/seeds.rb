require "open-uri"

Food.destroy_all
User.destroy_all
Ingredient.destroy_all
users = ["imnadleeh", "flxlng", "leamuno", "Octosub"]
users.each do |user_name|
  puts "creating #{user_name}"
  user = User.create(email: "#{user_name}@me.com", password: "123123")
  file = URI.open("https://kitt.lewagon.com/placeholder/users/#{user_name}")
  user.photo.attach(io: file, filename: "#{user_name}.jpg", content_type: "image/png")
end

ingredients = [
  "小麦粉", "パーム油", "なたね油混合油脂", "砂糖", "食塩", "カレー粉", "でん粉", "酵母エキス", "香辛料", "コーン油", "ゼラチン", "ハーブオイル", "カラメル色素", "酸味料", "チョコレートフラワーペースト", "マーガリン", "砂糖調製品砂糖", "パン酵母", "油脂加工品", "発酵風味料", "卵", "加工デンプン", "乳化剤", "pH調整剤", "香料", "イーストフード", "糊料", "キサンタン", "ビタミンC", "植物油脂", "ココアパウダー", "コーンスターチ", "膨張剤", "ショートニング", "乾燥ポテト", "野菜ペーストブイヨン混合品", "イースト", "小麦たんぱく", "酒かす", "コンソメシーズニング", "香味油", "こしょう", "無機塩", "大豆", "ぶどう糖果糖液糖", "バナナピューレ", "ペクチン", "セルロース", "クチナシ色素", "ソースパウダ", "なたね油", "唐辛子", "すりごま", "フライドオニオン", "フライドガーリック", "チキンブイヨン", "オニオンパウダー", "パプリカ", "油揚げめん小麦粉", "小麦グルテン", "しょうゆ", "チキン風味シーズニング", "チキン風味パウダー", "唐辛子シーズニング", "唐辛子加工品", "大豆油", "玉ねぎ", "香味食用油", "チキン風味調味料", "にんにく", "カレーシーズニングパウダー", "乳酸菌発酵粉末", "全粉乳", "脱脂粉乳", "チーズパウダー", "バターパウダー", "パセリ", "糊料加工澱粉", "グァー", "アミノ酸", "かんすい", "パプリカ色素", "V.B2", "香辛料抽出物", "微粒二酸化ケイ素", "水あめ", "カカオマス", "液卵", "乳糖", "ホエイパウダー", "ココアバター", "乳を主要原料とする食品", "洋酒", "クリームパウダー", "脱脂濃縮乳", "還元水あめ", "乾燥卵白", "卵黄", "乳たんぱく", "ソルビトール", "酒精", "大豆由来", "膨脹剤", "加工でん粉", "カラギーナ"
]

gtranslate_client = Google::Cloud::Translate::V2.new

ingredients.each do |ingredient|
  puts "creating #{ingredient}"
  e_trans = gtranslate_client.translate "#{ingredient}", to: "en"
  new_ingredient = Ingredient.create(name: ingredient, english_name: e_trans, english_description: "", vegan: "")
  p new_ingredient

end
