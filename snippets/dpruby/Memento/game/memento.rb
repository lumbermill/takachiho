class Memento
  attr_reader :money
  attr_accessor :fruits
  def initialize(money)
    @money = money
    @fruits = []
  end
end
