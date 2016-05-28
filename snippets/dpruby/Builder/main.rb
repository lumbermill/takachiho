require_relative "./director.rb"
require_relative "./htmlbuilder.rb"
require_relative "./textbuilder.rb"

if ARGV[0] == "plain"
  builder = TextBuilder.new
  director = Director.new(builder)
  director.construct
  puts builder.get_result
elsif ARGV[0] == "html"
  builder = HTMLBuilder.new
  director = Director.new(builder)
  director.construct
  puts builder.get_result+" was created."
else
  puts "#{$0} (plain|html)"
  exit 1
end
