# Ruby

## mysql2
```
require 'mysql2'

client = Mysql2::Client.new(host:"localhost",username:"root",database:"t")

name = client.escape("Y%")
results = client.query("SELECT * FROM t WHERE name LIKE '#{name}'")
p results.fields # Array
p results.count # Number of rows
results.each do |row|
  p row # Hash with Fixnum, Float, Date, Time etc..
end

client.query("INSERT INTO t VALUES (10,'C',now())")
p client.affected_rows
```

write and read blob data.
```
stat = client.prepare("insert into t (name,data) values (?,?)")
File.open("foo.jpg","rb") do |fh|
  stat.execute("foo.jpg",fh.read)
end

row = client.query("select name,data from t where id = 1").first
File.open(row['name'],'wb') do |fh|
  fh.write(row['data'])
end
```

See also rails.md(for using ActiveRecord).


## date
```
started = Time.now
elapsed = Time.now - started # second

require 'date'

d = Date.new(2015,6,18)
d.strftime("%G%V") # ISO week of year

require 'time'

t = Time.parse("2015-10-30")
t.strftime("%F %T") #=> "2015-10-30 00:00:00"

# Deprecated
dt = Datetime.parse("2001-02-03T04:05:06+07:00")
dt.strftime("%F %T") # ISO date and time
```

## file
```
fh = open("k_marimba.sql","r:cp932")
fh.each do |line|
  puts line
end
fh.close

Dir.exist? "/foo/bar"

Dir.chdir "/foo"



f = File.dirname(__FILE__)+"/../etc/foo.conf"
```

```
begin
  raise "runtime error!" #=> RuntimeError
  # raise Exception.new("exception!") #=> Exception
rescue => e
  $stderr.puts e 
# rescue Exception => e
#   $stderr.puts e
# else
#   $stdout.puts "else!"
ensure
  $stdout.puts "ensure!"
end
```

## optparse
```
require 'optparse'
Version = "1.0.0"

opt = OptionParser.new
opt.on('-d [DATE]') { |v| OPTS[:date] = Time.parse(v) }
opt.on('-s [STORE]') { |v| OPTS[:store] = v.to_i }
opt.on('-v [L]') { |v| OPTS[:v] = v.to_i }
opt.on('--slack') { |v| OPTS[:slack] = true }

OPTS = {}

opt.parse!(ARGV)
```

OR

```
require 'optparse'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: example.rb [options]"

  opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
    options[:verbose] = v
  end
end.parse!

p options
p ARGV
```

http://ruby-doc.org/stdlib-2.2.3/libdoc/optparse/rdoc/OptionParser.html

## main function
```
def main()
  # ..
end

if __FILE__ == $0
  main()
end
```

## json
```
require 'json'

my_hash = JSON.parse('{"hello": "goodbye"}')
puts my_hash["hello"] => "goodbye"
```

```
puts JSON.pretty_generate(my_hash)
```

## here document
```
html = <<-"EOT"

EOT
```

```
html = <<~"EOT"

EOT
```

## csv

```
require 'csv'


data = <<EOT
a,b,c
1,2,3
EOT

data = CSV.parse(data,headers: true)

# Read from file.
# data = CSV.read("example.csv", headers: true, encoding: "utf-8")

p data.headers
data.each do |row|
  p row
end
```
~                              


## その他

### エスケープシーケンスで文字に色をつける
```
puts "\e[31m"+"Hello, world."+"\e[m"
```

### self navigation operator
Objectがnilの場合に、エラーとせず、nilを返してくれるようになります。Ruby2.3以降で利用可能です。
```
> s&.to_i # s = "1000"
=> 1000
> s&.to_i # s = nil
=> nil
```
