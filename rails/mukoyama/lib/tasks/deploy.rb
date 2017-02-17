

#m = `rsync -crlpgoDv --exclude="tmp" --exclude="log" ./ sakura15:/opt/dev.mukoyama.lmlab.net/current/`
#puts m
#m = `ssh sakura15 sudo service httpd restart`
#puts m

def exec(cmd)
  puts cmd
  puts `#{cmd}`
end

# for developing linebot!!
exec("rsync -crlpgoDv ./app/ sakura16:/var/www/mukoyama/current/app/")
exec("ssh sakura16 sudo service httpd restart")
