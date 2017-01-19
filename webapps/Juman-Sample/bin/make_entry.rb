def entry(line)
  data = line.split(/\t/)
  dicttype = data[0]
  midashi  = data[1]
  daihyo   = data[2]
  yomi     = data[3]
  tmpl = '(名詞 (普通名詞 ((読み %s)(見出し語 %s)(意味情報 "代表表記:%s/%s ユーザ辞書:%s 意味分類:普通名詞その他:1.000"))))'
  entry = sprintf(tmpl,yomi,midashi,daihyo,yomi,dicttype)
  puts entry
end

def word_adjust(line)
  data = line.split(/\s+/)
  midashi = data[1]
  puts "\t#{midashi}\t"
end
entries=%q|
|

while (line = gets) do
  entry(line.chomp)
end
