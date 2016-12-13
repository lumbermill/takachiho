def upload_needed?
  u = "#{$url}/pictures/upload-needed?id=#{$id}&token=#{$token}"
  cmd = "curl -s -S '#{u}'"
  response = `#{cmd}`
  return (response == "Yes")
end

def interval_elapsed?
  now = Time.now
  if now.min % $taking_interval_min == 0 && now.min != $last_taken_time_by_inteval.min
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
end

if $0 == __FILE__
  #cronから起動。
  #ロックファイルが存在するとき
  #  ロックファイルに書かれたPIDが存在するならプログラム終了
  #  ロックファイルに書かれたPIDが存在しないならロックファイルを削除してOSリブート
  #ロックファイルがなければロックファイルにPIDを書き出して継続

  filename = "/tmp/photo.jpg"
  $url = ENV["MUKOYAMA_URL"]
  $id = ENV["MUKOYAMA_ID"]
  $token = ENV["MUKOYAMA_TOKEN"]
  $taking_interval_min = 10 #毎10分ごとに撮影
  $last_taken_time_by_inteval = Time.now
  while (true) do
    if uplodable?
      take_picture(filename)
      send_picture(filename)
    end
    sleep 1
  end
end
