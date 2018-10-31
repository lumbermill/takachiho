
require 'hue'
 
hue = Hue::Client.new
kitchen = hue.groups[0]
coworking = hue.groups[1]
go = kitchen.lights[0]

indexes = [0,7,5,2,1,4]
state = {
  hue: rand(Hue::Light::HUE_RANGE),
  saturation: rand(Hue::Light::BRIGHTNESS_RANGE),
  brightness: rand(Hue::Light::SATURATION_RANGE)
}

#state = {hue:33016, saturation:53, brightness:254, color_tempareture:230}

go.set_state(state,4)

indexes.each do |i|
  l = coworking.lights[i]
  l.set_state(state,10)
  puts "#{i}: #{l.id}  #{l.hue} #{l.saturation} #{l.brightness} #{l.color_temperature}"
end

