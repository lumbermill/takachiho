#! /usr/bin/ruby
# Takes pictures using raspistill command.
count = 1
loop do
  txt = gets
  exit if txt.strip == "exit"
  fname = "%04i.jpg" % count
  cmd = "raspistill -w 320 -h 320 -o #{fname} -t 2000"
  puts cmd
  ret = `#{cmd}`
  if $? == 0 && ret.empty?
    puts fname
  else
    puts ret
  end
  count += 1
end
