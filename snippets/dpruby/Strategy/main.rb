require_relative './winningstrategy.rb'
require_relative './probstrategy.rb'
require_relative './player.rb'
require_relative './hand.rb'

unless ARGV.length == 2
  puts "USAGE: #{$0} seed1 seed2"
  puts "EX   : #{$0} 123 456"
  exit 1
end

seed1 = ARGV[0].to_i
seed2 = ARGV[1].to_i
player1 = Player.new("Taro",WinningStrategy.new(seed1))
player2 = Player.new("Hana",ProbStrategy.new(seed2))
10000.times do |i|
  h1 = player1.next_hand
  h2 = player2.next_hand
  if h1.is_stronger_than(h2)
    puts "Winner: #{player1}"
    player1.win
    player2.lose
  elsif h2.is_stronger_than(h1)
    puts "Winner: #{player2}"
    player1.lose
    player2.win
  else
    puts "Even.."
    player1.even
    player2.even
  end
end
