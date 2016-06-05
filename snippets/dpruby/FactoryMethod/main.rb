require_relative './idcardfactory.rb'

factory = IDCardFactory.new
card1 = factory.create("Alice")
card2 = factory.create("Bob")
card3 = factory.create("Chris")
card1.use
card2.use
card3.use
puts factory.owners.count
