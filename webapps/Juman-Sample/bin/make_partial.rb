def partial(line)
  data = line.split(/\s+/)
  midashi = data[1]
  puts "\t#{midashi}\t"
end

while (line = gets) do
  partial(line.chomp)
end

