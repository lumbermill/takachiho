require_relative './numbergenerator.rb'

class RandomNumberGenerator < NumberGenerator
  attr_reader :number

  def execute
    20.times do |i|
      @number = (rand * 50).to_i
      notify_observers
    end
  end
end
