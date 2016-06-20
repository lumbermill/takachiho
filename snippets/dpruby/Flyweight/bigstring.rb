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
    5.times do |i|
      @bigchars.each do |b|
        Kernel.print b.fontdata[i]+"."
      end
      Kernel.print "\n"
    end
  end
end
