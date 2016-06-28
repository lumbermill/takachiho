require_relative './game/gamer.rb'

gamer = Gamer.new(100)
memento = gamer.create_memento

100.times do |i|
  puts "==== #{i}"
  puts "Current: #{gamer}"

  gamer.bet

  puts "You have #{gamer.money} yen now."

  if gamer.money > memento.money
    puts "  (Saving current status.)"
    memento = gamer.create_memento
  elsif gamer.money < memento.money / 2
    puts "  (Going back to previous state.)"
    gamer.restore_memento(memento)
  end

  sleep 1
  puts ""
end
