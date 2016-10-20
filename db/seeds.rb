# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#

# categories
categories = []
categories << ["ニュース／報道", [
  "定時・総合", "天気", "特集・ドキュメント", "政治・国会", "経済・市況",
  "海外・国際", "解説", "討論・会談", "報道特番", "ローカル・地域", "交通"]]
categories << ["スポーツ", [
  "スポーツニュース", "野球", "サッカー", "ゴルフ", "その他の球技",
  "相撲・格闘技", "オリンピック・国際大会", "マラソン・陸上・水泳",
  "モータースポーツ", "マリン・ウインタースポーツ", "競馬・公営競技", "その他"]]
categories << ["情報／ワイドショー", [
  "芸能・ワイドショー", "ファッション", "暮らし・住まい", "健康・医療",
  "ショッピング・通販", "グルメ・料理", "イベント", "番組紹介・お知らせ", "その他"]]
categories << ["ドラマ", [
  "国内ドラマ", "海外ドラマ", "時代劇", "その他"]]
categories << ["音楽", [
  "国内ロック・ポップス", "海外ロック・ポップス", "クラシック・オペラ",
  "ジャズ・フュージョン", "歌謡曲・演歌", "ライブ・コンサート",
  "ランキング・リクエスト", "カラオケ・のど自慢", "民謡・邦楽", "童謡・キッズ",
  "民族音楽・ワールドミュージック", "その他"]]
categories << ["バラエティ", [
  "クイズ", "ゲーム", "トークバラエティ", "お笑い・コメディ", "音楽バラエティ",
  "旅バラエティ", "料理バラエティ", "その他"]]
categories << ["映画", [
  "洋画", "邦画", "アニメ", "その他"]]
categories << ["アニメ／特撮", [
  "国内アニメ", "海外アニメ", "特撮", "その他"]]
categories << ["ドキュメンタリー／教養", [
  "社会・時事", "歴史・紀行", "自然・動物・環境", "宇宙・科学・医学",
  "カルチャー・伝統文化", "文学・文芸", "スポーツ", "ドキュメンタリー全般",
  "インタビュー・討論", "その他"]]
categories << ["劇場／公演", [
  "現代劇・新劇", "ミュージカル", "ダンス・バレエ", "落語・演芸",
  "歌舞伎・古典", "その他"]]

categories << ["趣味／教育", [
  "旅・釣り・アウトドア", "園芸・ペット・手芸", "音楽・美術・工芸",
  "囲碁・将棋", "麻雀・パチンコ", "車・オートバイ", "コンピュータ・ＴＶゲーム",
  "会話・語学", "幼児・小学生", "中学生・高校生", "大学生・受験",
  "生涯教育・資格", "教育問題", "その他"]]
categories << ["福祉", [
  "高齢者", "障害者", "社会福祉", "ボランティア", "手話", "文字（字幕）",
  "音声解説"]]
categories << ["その他", ["その他"]]

categories.each do |category|
  main_category = category[0]
  mc = MainCategory.create(name: main_category)
  category[1].each do |sub_category|
    mc.sub_categories.create(name: sub_category)
  end
end
