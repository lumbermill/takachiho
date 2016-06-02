require_relative './display.rb'
require_relative './sideborder.rb'
require_relative './stringdisplay.rb'
require_relative './fullborder.rb'

b1 = StringDisplay.new("Hello, world!!")
b2 = SideBorder.new(b1,"#")
b3 = FullBorder.new(b2)
b1.show
b2.show
b3.show
b4 = SideBorder.new(FullBorder.new(FullBorder.new(SideBorder.new(FullBorder.new(StringDisplay.new("Hello, again!!")),"*"))),"/")
b4.show
