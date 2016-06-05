require_relative './abstractdisplay.rb'
require_relative './chardisplay.rb'
require_relative './stringdisplay.rb'

d1 = CharDisplay.new("Hi!")
d2 = StringDisplay.new("Hello, world!")
d1.display
d2.display
