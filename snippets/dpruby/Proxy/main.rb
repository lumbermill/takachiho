require_relative './printer.rb'
require_relative './printerproxy.rb'

p = PrinterProxy.new("Alice")
puts p.name
p.name = "Bob"
puts p.name
p.print "Hello, world!"
