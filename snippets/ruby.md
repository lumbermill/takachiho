# Ruby

## mysql2
```
require 'mysql2'

client = Mysql2::Client.new(host:"localhost",username:"root",database:"t")

name = client.escape("Y%")
results = client.query("SELECT * FROM t WHERE name LIKE '#{name}'")
p results.fields # Array
results.each do |row|
  p row # Hash with Fixnum, Float, Date, Time etc..
end

client.query("INSERT INTO t VALUES (10,'C',now())")
p client.affected_rows
```

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
Ruby optparse
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
