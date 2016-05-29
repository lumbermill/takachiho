class Trouble
  attr_reader :number
  def initialize(number)
    @number = number
  end

  def to_s
    "Trouble #{@number}"
  end
end
