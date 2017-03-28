require 'fileutils'
MOTION_SENSOR = 14 # 人感センサーのGPIO番号

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

@wait_count = 0
def sensor_responding?
  @wait_count -= 1 if @wait_count > 0
  # gpioの起動 TODO:毎回起動&停止をしてもいいのか？
  `echo #{MOTION_SENSOR} > /sys/class/gpio/export`
  # gpioの起動状況を確認
  gpio = `sudo cat /sys/class/gpio/gpio#{MOTION_SENSOR}/value`.to_i
  # gpioの停止
  `echo #{MOTION_SENSOR} > /sys/class/gpio/unexport`
  if gpio == 1 && @wait_count <= 0
    @wait_count = $motion_sensor_interval
    return true
  else
    return false
  end
end

def uplodable?
  $motion_sensor = sensor_responding?
  upload_needed? || interval_elapsed? || $motion_sensor
end

def take_picture(filename)
  cmd = "raspistill -n -t 1 -q 50 -w 640 -h 480 -o #{filename}"
  system(cmd)
end

def send_picture(filename)
  ts = Time.now.strftime("%Y-%m-%dT%H:%M:%S%z")
  u = "#{$url}/pictures/upload?id=#{$id}&token=#{$token}&time_stamp=#{ts}&motion_sensor=#{$motion_sensor.to_s}"
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
  $motion_sensor_interval = 10 #モーションセンサの反応間隔(秒)
  $last_taken_time_by_inteval = -1
  $motion_sensor = false # 人感センサーに反応したかどうか
  while (true) do
    if uplodable?
      take_picture(filename)
      send_picture(filename)
    end
    sleep 1
  end
end
