require 'fileutils'

def process_exist?(pid)
  cmd = "ps #{pid}"
  `#{cmd}`
  return ($? == 0)
end

def upload_needed?
  u = "#{$url}/pictures/upload-needed?id=#{$id}&token=#{$token}"
  cmd = "curl -s -S '#{u}'"
  response = `#{cmd}`
  return (response == "Yes")
end

def interval_elapsed?
  now = Time.now.min
  if now % $taking_interval_min == 0 && now != $last_taken_time_by_inteval
    $last_taken_time_by_inteval = now
    return true
  else
    return false
  end
end

def uplodable?
  upload_needed? || interval_elapsed?
end

def take_picture(filename)
  cmd = "raspistill -n -t 1 -q 50 -w 640 -h 480 -o #{filename}"
  system(cmd)
end

def send_picture(filename)
  ts = Time.now.strftime("%Y-%m-%dT%H:%M:%S%z")
  u = "#{$url}/pictures/upload?id=#{$id}&token=#{$token}&time_stamp=#{ts}"
  cmd = "curl -s -S -X POST -F file=@'#{filename}' '#{u}'"
  system(cmd)
  puts
end

if $0 == __FILE__
  #cronから毎分起動。
  lockfile = "/var/lock/mcamera.pid"
  if File.exist?(lockfile)
    #ロックファイルが存在するとき
    open(lockfile) do|f|
      pid = f.readline.chomp
      if process_exist?(pid)
        #ロックファイルに書かれたPIDが存在するならプログラム終了
        puts "This program is already active."
        exit
      else
        #ロックファイルに書かれたPIDが存在しないならロックファイルを削除してOSリブート
        puts "This program might have aborted. Operating System will reboot."
        FileUtils.rm(lockfile)
        system("sudo reboot")
        exit
      end
    end
  else
    #ロックファイルがなければロックファイルにPIDを書き出して継続
    open(lockfile, "w") do|f|
      f.puts $$
    end
  end

  filename = "/tmp/photo.jpg"
  $url = ENV["MUKOYAMA_URL"]
  $id = ENV["MUKOYAMA_ID"]
  $token = ENV["MUKOYAMA_TOKEN"]
  $taking_interval_min = 10 #毎10分ごとに撮影 60の役数(10,15,20,30..)のみ指定可能
  $last_taken_time_by_inteval = -1
  while (true) do
    if uplodable?
      take_picture(filename)
      send_picture(filename)
    end
    sleep 1
  end
end
