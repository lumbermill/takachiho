class IDCard
  attr_reader :owner
  def initialize(owner)
    @owner = owner
    puts "Making #{self}."
  end

  def use
    puts "Using #{self}."
  end

  def to_s
    "#{@owner}'s card'"
  end
end
