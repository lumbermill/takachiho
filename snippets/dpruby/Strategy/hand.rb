class Hand
  STONE = 0
  SCISSORS = 1
  PAPER = 2
  attr_reader :value

  def initialize(v)
    @value = v
  end
  
  @@hands = [Hand.new(STONE),Hand.new(SCISSORS),Hand.new(PAPER)]
  @@names = ["Stone","Scissors","Paper"]
  class << self
    protected :new

    def hand(v)
      raise "#{v} is not in 0-2" unless 0 <= v && v <= 2
      @@hands[v]
    end
  end

  def is_stronger_than(h)
    fight(h) == 1
  end

  def is_weaker_than(h)
    fight == -1
  end

  def to_s
    return @@name[@value]
  end

  private
    def fight(h)
      if self == h
        return 0
      elsif (@value + 1) % 3 == h.value
        return 1
      else
        return -1
      end
    end
end
