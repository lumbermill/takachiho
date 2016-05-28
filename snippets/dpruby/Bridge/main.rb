require_relative './stringdisplayimpl.rb'
require_relative './countdisplay.rb'

d1 = Display.new(StringDisplayImpl.new("Good morining!"))
d2 = CountDisplay.new(StringDisplayImpl.new("Good night!"))

d1.display
d2.display
d2.multi_display(5)
