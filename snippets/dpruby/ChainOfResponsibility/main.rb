require_relative './support.rb'
require_relative './trouble.rb'
require_relative './limitsupport.rb'
require_relative './limitsupport.rb'
require_relative './nosupport.rb'
require_relative './oddsupport.rb'
require_relative './specialsupport.rb'

t1 = NoSupport.new("Alice")
t2 = LimitSupport.new("Bob",100)
t3 = SpecialSupport.new("Charlie",429)
t4 = LimitSupport.new("Diana",200)
t5 = OddSupport.new("Elmo")
t6 = LimitSupport.new("Fred",300)

t1.next(t2).next(t3).next(t4).next(t5).next(t6)

500.times do |i|
  t1.support(Trouble.new(i))
end
