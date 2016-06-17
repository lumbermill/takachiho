require_relative './commandlistnode.rb'
require_relative './commandnode.rb'
require_relative './context.rb'
require_relative './primitivecommandnode.rb'
require_relative './programnode.rb'
require_relative './repeatcommandnode.rb'

fh = open('program.txt')
fh.each do |line|
  puts line
  node = ProgramNode.new
  node.parse(Context.new(line))
  puts "node = #{node}"
end
# TODO: 書きかけ！ここから6/16
