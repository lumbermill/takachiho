require_relative './bigstring.rb'

if ARGV.length == 0
  puts "USAGE: #{$0} 123456"
  exit 1
end

bs = BigString.new(ARGV[0])
bs.print
