# Converts image files in the directory.

BASEDIR="."
OUTDIR="./out"
# options for tomica images
CONVERT_OPTS="-fuzz 20% -trim -resize 640x640 -strip"
# options for beer images
# CONVERT_OPTS="-resize 640x640 -rotate 90 -strip"

`mkdir -p #{OUTDIR}`
puts "Convert with: "+CONVERT_OPTS

Dir.entries(BASEDIR).each do |f|
  src = BASEDIR+"/"+f
  next unless File.file? src
  next unless f.end_with? ".jpg"
  dst = OUTDIR+"/"+f
  puts f + " -> " +dst
  cmd = "convert #{CONVERT_OPTS} #{src} #{dst}"
  m = `#{cmd}`
  if $? != 0 || !m.empty?
    puts m
  end
end
