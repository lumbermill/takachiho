require "#{File.expand_path(File.dirname(__FILE__))}/parse.rb"

def pick_midashi(parsed)
  #pp parsed
  e = parsed.shift
  if e == "見出し語"
    puts  parsed[0]
  else
    pick_midashi(parsed[0])
  end
end

while(line=gets) do
  line.chomp!
  next if line.empty?
  begin
    pick_midashi(parse(line))
  rescue Exception => e
    puts "文法エラー:#{line}"
    puts e
    exit -1
  end
end
