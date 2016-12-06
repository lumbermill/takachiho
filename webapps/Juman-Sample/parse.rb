require 'pp'
def parse(s)
  tokens = tokenize(s)
  read_from(tokens)
end

def tokenize(s)
  raise 'begined without parenthesis' if s !~ /^\(/
  s.gsub('(', ' ( ').gsub(')', ' ) ').split
end

def read_from(tokens)
  raise 'unexpected EOF while reading' if tokens.empty?
  token = tokens.shift
  if '(' == token
    l = []
    l << read_from(tokens) while tokens[0] != ')'
    tokens.shift                # ')' を削除
    l
  elsif token =~ /^\"/
    # "で始まるトークンから"で終わるトークンまでは一つのトークンとしてまとめる
    while (next_token = tokens.shift) do
      token += " " + next_token 
      break if next_token =~ /\"$/
    end
    token
  else
    token
  end
end

if $0 == __FILE__
  while(line=gets) do
    line.chomp!
    next if line.empty?
    begin
      pp parse(line)
    rescue Exception => e
      puts "文法エラー:#{line}"
      puts e
      exit -1
    end
  end
end
