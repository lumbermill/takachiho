
require 'open-uri'

def each_url_list
  Dir.glob("./url_lists/*") do |list|
    yield(list)
    break
  end
end

def each_url(url_list)
  File.foreach(url_list) do |url|
    yield(url)
  end	
end

def get_contnet(url)
  open(url) do |content|
    c = content.read
    c.gsub!(/<head.+\/head>/m,"")         # <head>タグの中身を削除
    c.gsub!(/<script.+\/script>/m,"")     # <script>タグの中身削除
    c.gsub!(/<noscript.+\/noscript>/m,"") # <noscript>タグの中身を削除
    c.gsub!(/<\/?[^>]*>/m,"")             # タグを全て除去
    c.gsub!(/。/,"。\n")                  # "。"を"。\n"に置換(１行が長すぎるとknpエラーになる)
    c.gsub!(/ /,"/")                      # 半角スペースを'/'に置換(knpエラー回避)
    c.gsub!(/\+/,"＋")                    # 半角'+'を全角'＋'に置換(knpエラー回避)
  end
end

each_url_list do |list|
  each_url(list) do |url|
    url.chomp!
    puts get_contnet(url)
# テンポラリファイルに保存
  end
end
