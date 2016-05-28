require_relative './display.rb'

class CountDisplay < Display
  def initialize(impl)
    super(impl)
  end

  def multi_display(times)
    open
    times.times do |i|
      print
    end
    close
  end
end
