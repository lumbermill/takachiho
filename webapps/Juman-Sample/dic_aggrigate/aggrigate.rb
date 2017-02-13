# URLリストを読み込む
# URLからコンテンツを取ってくる
# <body>タグの内部だけを対象にする
# コンテンツからタグを除去 str.gsub(/<\/?[^>]*>/
# "。"を"。\n"に置換(１行が長すぎるとknpエラーになる)
# 半角スペースを'/'に置換(knpエラー回避)
# 半角'+'を全角'＋'に置換(knpエラー回避)
# テンポラリファイルに保存
def each_url_list
  Dir.glob("./url_lists/*") do |list|
    yield(list)
  end
end

def each_url(url_list)
  File.foreach(url_list) do |url|
    yield(url)
  end	
end

def get_contnet(url)
puts url
end

each_url_list do |list|
  each_url(list) do |url|
    get_contnet(url)
  end
end
