require_relative './memento.rb'

class Gamer
  FRUITS = ["apple","grape","banana","orange"]

  attr_reader :money
  def initialize(money)
    @money = money
    @fruits = []
  end

  def bet
    dice = (rand * 6).to_i + 1
    if dice == 1
      @money += 100
      puts "You earned money."
    elsif dice == 2
      @money /= 2
      puts "You lost the half of your money."
    elsif dice == 6
      f = fruit
      puts "You got a fruit(#{f})."
      @fruits += [f]
    else
      puts "Nothing happened."
    end
  end

  def create_memento
    m = Memento.new(@money)
    @fruits.each do |f|
      m.fruits += [f] if f.start_with? "delicious"
    end
    return m
  end

  def restore_memento(m)
    @money = m.money
    @fruits = m.fruits.clone
  end

  def to_s
    "[money=#{@money}, fruits=#{@fruits.join(",")}]"
  end

  private
    def fruit
      prefix = ""
      if rand < 0.5
        prefix = "delicious "
      end
      prefix + FRUITS[(rand * FRUITS.length)]
    end
end
