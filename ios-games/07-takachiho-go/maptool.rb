
# Google のEmbed用URLから経度、緯度を抽出
# 「名前 URL」の順に半角スペース区切りで列挙してください
def url2latlng(file='links.txt')
  open(file).each do |line|
    next if line.start_with? "#"
    name,url = line.split(" ")
    m = url.match /!3d([0-9.]+)!4d([0-9.]+)?/
    puts name
    puts m[1]+"\t"+m[2]
    puts "http://maps.google.com/maps?q=#{m[1]},#{m[2]}"
  end
end

# SpreadsheetのデータをSwiftのオブジェクト配列定義に変換
# 高千穂の神社: https://docs.google.com/spreadsheets/d/1iejyqqEBWc277BdT93RkhY3FVdulfRTZsLET2lhY7FU/edit?usp=sharing
def sheet2array(file='shrines.txt')
  open(file).each do |line|
    v = line.strip.split("\t")
    puts "array += [Point(\"#{v[0]}\", kanji:\"#{v[1]}\", lat:#{v[2]}, lng:#{v[3]},difficulty:#{v[4]})]"
  end
end

if __FILE__ == $0
  url2latlng(ARGV[0])
end
