require_relative './singleton.rb'

obj1 = MySingleton.instance
obj2 = MySingleton.instance

if obj1 == obj2
  puts "Same!"
else
  puts "Not equal."
end
