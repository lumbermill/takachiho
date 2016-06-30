class WinningStrategy
  def initialize(seed)
    @random = Random.new(seed)
    @won = false
  end

  def next_hand
    unless @won
      @prev_hand = Hand.hand(@random.rand(3))
    end
    @prev_hand
  end

  def study(win)
    @won = win
  end
end
