h = ARGV[0].to_i
puts h
require 'hue'
 
hue = Hue::Client.new
coworking = hue.groups[1]
kitchen = hue.groups[0]
go1 = kitchen.lights[0]
go2 = kitchen.lights[3]
go3 = kitchen.lights[4]

b = 100
red    = {hue:0,     saturation:254, brightness:b, color_tempareture:100}
yellow = {hue:10922, saturation:254, brightness:b, color_tempareture:100}
green  = {hue:21845, saturation:254, brightness:b, color_tempareture:100}

go1.set_state(yellow,4)
go2.set_state(yellow,4)
go3.set_state(yellow,4)

go1.on = false
go2.on = false
go3.on = false

sleep(1)
exit
loop do 
go1.on = true
sleep(5)
go1.on = false
go3.on = true
sleep(3)
go3.on = false
go2.on = true
sleep(1)
go2.on = false
end

