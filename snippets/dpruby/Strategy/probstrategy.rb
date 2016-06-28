class ProbStrategy
  def initialize(seed)
    @random = Random.new(seed)
    @prev_hand_value = 0
    @current_hand_value = 0
    @history = [[1,1,1],[1,1,1],[1,1,1]]
  end

  def next_hand
    bet = @random.rand(sum(@current_hand_value))
    hand_value = 0
    if bet < @history[@current_hand_value][0]
      hand_value = 0
    elsif bet < @history[@current_hand_value][0] + @history[@current_hand_value][1]
      hand_value = 1
    else
      hand_value = 2
    end
    @prev_hand_value = @current_hand_value
    @current_hand_value = hand_value
    Hand.hand(hand_value)
  end

  def study(win)
    if win
      @history[@prev_hand_value][@current_hand_value] += 1
    else
      @history[@prev_hand_value][(@current_hand_value + 1) % 3] += 1
      @history[@prev_hand_value][(@current_hand_value + 1) % 3] += 1
    end
  end

  private
    def sum(hand_value)
      @history[hand_value].reduce(:+)
    end
end
