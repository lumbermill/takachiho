while (line=gets) do
  next if line =~ /^%s+;/
  midashi = line.scan(/\(見出し語(.+?)\)/)
  unless midashi.empty?
    puts "\t#{midashi.flatten[0]}\t"
  end
end
