require_relative './randomnumbergenerator.rb'
require_relative './digitobserver.rb'
require_relative './graphobserver.rb'

generator = RandomNumberGenerator.new
ob1 = DigitObserver.new
ob2 = GraphObserver.new
generator.add_observer(ob1)
generator.add_observer(ob2)
generator.execute
