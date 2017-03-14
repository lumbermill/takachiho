10.times do |i|
	f="/var/www/pictures/%03i.jpg" % i
	`raspistill -t 1 -vf -hf -o #{f}`
end

