

m = `rsync -crlpgoDv --exclude="tmp" --exclude="log" ./ sakura15:/opt/dev.mukoyama.lmlab.net/current/`
puts m
m = `ssh sakura15 sudo service httpd restart`
puts m
