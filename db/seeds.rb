require "open-uri"
require "deepl"
require "json"

Favorite.destroy_all
Food.destroy_all
# Ingredient.destroy_all


# file = File.read('./ingredients.json')
# ingredients = JSON.parse(file)

# ingredients.each do |ingredient|
#   Ingredient.create(ingredient)
# end


ingredients = [
  "砂糖", "食塩", "発酵風味料", "カレー粉", "マーガリン", "でん粉", "酵母エキス", "香辛料", "パン酵母", "コーン油", "ゼラチン", "加工デンプン", "ハーブオイル", "油脂加工品", "カラメル色素", "酸味料", "卵", "乳化剤", "香料", "イーストフード", "酒かす", "糊料", "キサンタン", "大豆", "ビタミンC", "コンソメシーズニング", "植物油脂", "ココアパウダー", "コーンスターチ", "香味油", "膨張剤", "ショートニング", "バナナピューレ", "乾燥ポテト", "こしょう", "野菜ペーストブイヨン混合品", "イースト", "ぶどう糖果糖液糖", "小麦たんぱく", "無機塩", "ペクチン", "セルロース", "クチナシ色素", "チキン風味パウダー", "ソースパウダ", "なたね油", "香味食用油", "唐辛子", "唐辛子シーズニング", "すりごま", "フライドオニオン", "フライドガーリック", "唐辛子加工品", "ピーナッツ", "カレー", "澱粉", "しょう油", "味付豚ミンチ", "寒梅粉", "香味", "デキストリン", "のり", "ブドウ糖", "人参", "はちみつ", "ねぎ", "糊料プルコン", "ピーナッツバター", "ポークエキス", "かんすい", "液卵", "パプリカ色素", "洋酒", "香辛料抽出物", "乳を主要原料とする食品", "乳糖", "ホエイパウダー", "クリームパウダー", "脱脂濃縮乳", "還元水あめ", "乾燥卵白", "卵黄", "乳たんぱく", "ソルビトール", "酒精", "大豆由来", "膨脹剤", "加工でん粉", "カラギーナ", "味付豚肉", "チキンエキス", "フライドポテト", "豚脂", "炭酸Ca", "増粘多", "カロチノイド色素", "くん液", "ビタミンB2", "ビタミンB1", "乾燥じゃがいも", "米粉", "とうもろこし", "しょうゆ大豆を含む", "調味パウダー豚肉を含む", "塩化Mg", "小麦粉", "なたね油混合油脂", "パーム油", "チョコレートフラワーペースト", "チキンブイヨン", "オニオンパウダー", "にんにく", "パプリカ", "大豆油", "小麦グルテン", "しょうゆ", "チキン風味調味料", "チキン風味シーズニング", "玉ねぎ", "カレーシーズニングパウダー", "乳酸菌発酵粉末", "微粒二酸化ケイ素", "全粉乳", "脱脂粉乳", "チーズパウダー", "水あめ", "バターパウダー", "パセリ", "ココアバター", "糊料加工澱粉", "カカオマス", "グァー", "じゃがいも", "米油", "青のり", "あおさ", "ほたてエキスパウダー", "ごま油", "植物油", "こんぶエキスパウダー", "ご飯", "サーモントラウト西京焼", "玉子焼", "切干大根煮", "ひじき煮", "がんもどき煮", "だし入り醤油たれ", "人参煮", "れんこん煮漬物", "いんげん", "ごま", "増粘剤"
]

# "ピーナッツバター"

ingredients.each do |ingredient|
  puts "creating #{ingredient}"
  e_trans = DeepTranslator.translate_ingredient(ingredient).downcase
  new_ingredient = Ingredient.create(name: ingredient, english_name: e_trans)
  Gpt.classify_ingredient(new_ingredient)
  Gpt.describe_ingredient(new_ingredient)
end

puts "Created #{Ingredient.all.count} ingredients"
