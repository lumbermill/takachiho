require 'open-uri'
require 'tempfile'
LEBYR_ROOT       = ENV['LEBYR_ROOT'] || '/home/ubuntu/src/lebyr'
LEBYR_PREFS      = ENV['LEBYR_PREFS'] || "./lebyr_prefs"
JUMAN_PERL_ROOT  = ENV['JUMAN_PERL_ROOT'] || LEBYR_ROOT + '/../juman-7.01/perl/blib/lib'
KNP_PERL_ROOT    = ENV['KNP_PERL_ROOT'] || LEBYR_ROOT + '/../knp-4.16/perl/lib'
JUMAN_PREFIX     = ENV['JUMAN_PREFIX'] || '/usr/local'
JUMANPP_ROOT     = ENV['JUMANPP_ROOT'] || '/home/ubuntu/src/jumanpp-1.01'
LEBYR_DICDIR     = '/tmp/adic'
JUMANPP_DIC      = JUMANPP_ROOT + '/dict-build'
JUMANPP_USER_DIC = JUMANPP_DIC + '/userdic'

#既存辞書をlebyrに取り込む
def prepare_lebyr_dic
  system("cd #{LEBYR_ROOT} && ./importdic_jumanpp.sh")
end

def url_encode_on_demand(url)
  if (url.ascii_only?)
    return url
  else
    return URI.encode(url)
  end
end

def each_url_list
  Dir.glob("./url_lists/*") do |list|
    puts "LIST FILE:#{list}"
    yield(list)
  end
end

def each_url(url_list)
  File.foreach(url_list) do |url|
    puts "URL:#{url}"
    yield(url)
  end	
end

def get_contnet(url)
  c = ""
  begin
    open(url_encode_on_demand(url)) do |content|
      c = content.read
      c.gsub!(/<head.+\/head>/m,"")         # <head>タグの中身を削除
      c.gsub!(/<script.+\/script>/m,"")     # <script>タグの中身削除
      c.gsub!(/<noscript.+\/noscript>/m,"") # <noscript>タグの中身を削除
      c.gsub!(/<\/?[^>]*>/m,"")             # タグを全て除去
      c.gsub!(/\+/,"＋")                    # 半角'+'を全角'＋'に置換(knpエラー回避)
      c.gsub!(/\s+/, "\n")                   # 空白文字の繰り返しを'\n'に置換(knpエラー回避)
      c.gsub!(/。/,"。\n")                  # "。"を"。\n"に置換(１行が長すぎるとknpエラーになる)
    end
  rescue => e
    $stderr.puts "CANNOT OPEN URL:#{url}"
    $stderr.puts e
  end
  return c
end

def lebyr(copus_src)
  lebyr_cmd  = "JUMAN_PREFIX=#{JUMAN_PREFIX}"
  lebyr_cmd += " perl -I#{LEBYR_ROOT}/lib -I#{JUMAN_PERL_ROOT} -I#{KNP_PERL_ROOT} #{LEBYR_ROOT}/unknown/sequential.pl"
  lebyr_cmd += " --conf=#{LEBYR_PREFS} --monitor --dicdir=#{LEBYR_DICDIR} --raw #{copus_src} --debug"
  system(lebyr_cmd)
end

# 未知語の取得
def get_unknown
  prepare_lebyr_dic
  Tempfile.create("lebyr-aggrigate") do |f|
    each_url_list do |list|
      each_url(list) do |url|
        url.chomp!
        f.puts get_contnet(url) # テンポラリファイルに保存
      end
    end
    lebyr(f.path) # テンポラリファイルを取得元としてlebyrに与え、未知語の辞書を作成する
  end
end

# 未知語辞書の配備
def deploy_dict
  dict_name = Time.now.strftime("%Y%m%d-%H%M%S") + ".dic"
  FileUtils.mkdir_p(JUMANPP_USER_DIC)
  FileUtils.cp(LEBYR_DICDIR + "/output.dic", JUMANPP_USER_DIC + "/#{dict_name}")
  system("cd #{JUMANPP_DIC} && pwd && make && sudo ./install.sh")
end

get_unknown
deploy_dict
# TODO: 解析誤りの修正
