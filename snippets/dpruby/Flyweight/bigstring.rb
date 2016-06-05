require_relative './bigchar.rb'
require_relative './bigcharfactory.rb'

class BigString
  def initialize(str)
    @bigchars = []
    factory = BigCharFactory.instance
    str.each_char do |chr|
      @bigchars += [factory.bigchar(chr)]
    end
  end

  def print
    @bigchars.each do |b|
      b.print
    end
  end
end
