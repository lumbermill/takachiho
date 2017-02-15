require 'open-uri'
require 'tempfile'
LEBYR_ROOT      = ENV['LEBYR_ROOT'] || '/home/ubuntu/src/lebyr'
JUMAN_PERL_ROOT = ENV['JUMAN_PERL_ROOT'] || LEBYR_ROOT + '/../juman-7.01/perl/blib/lib'
KNP_PERL_ROOT   = ENV['KNP_PERL_ROOT'] || LEBYR_ROOT + '/../knp-4.16/perl/lib'

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
    c.gsub!(/\+/,"＋")                    # 半角'+'を全角'＋'に置換(knpエラー回避)
    c.gsub!(/\s+/, "\n")                   # 空白文字の繰り返しを'\n'に置換(knpエラー回避)
    c.gsub!(/。/,"。\n")                  # "。"を"。\n"に置換(１行が長すぎるとknpエラーになる)
  end
end

def lebyr(copus_src)
  lebyr_cmd =  "perl -I#{LEBYR_ROOT}/lib -I#{JUMAN_PERL_ROOT} -I#{KNP_PERL_ROOT} #{LEBYR_ROOT}/unknown/sequential.pl"
  lebyr_cmd += " --conf=#{LEBYR_ROOT}/prefs --monitor --dicdir=/tmp/adic --raw #{copus_src} --debug"
  system(lebyr_cmd)
end

each_url_list do |list|
  Tempfile.create("lebyr-aggrigate-" + File.basename(list)) do |f|
    each_url(list) do |url|
      url.chomp!
      f.puts get_contnet(url) # テンポラリファイルに保存
    end
    lebyr(f.path) # テンポラリファイルを取得元としてlebyrに与え、未知語の辞書を作成する
  end
end
# TODO: 辞書の配備・既存辞書の置き換え・コンパイル等
