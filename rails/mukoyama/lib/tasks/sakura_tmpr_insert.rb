require 'fileutils'
require 'rubygems'
require 'websocket-client-simple'
require 'json'

def process_exist?(pid)
  cmd = "ps #{pid}"
  `#{cmd}`
  return ($? == 0)
end

def get_tmpr
  threads = []

  SakuraIotModule.all.each do |m|
    t = Thread.new do
      ws = WebSocket::Client::Simple.connect "wss://api.sakura.io/ws/v1/#{m.token}"
      ws.on :message do |msg|
        data = JSON.parse(msg.data)
        next unless data["type"] == "channels"
        tmpr_data = data["payload"]["channels"]
        tmpr_log = TmprLog.new({raspi_id: m.raspi_id, time_stamp: data["datetime"], temperature: tmpr_data[0]["value"], pressure: tmpr_data[1]["value"], humidity: tmpr_data[2]["value"],sender: data["module"]})
        tmpr_log.save
      end
      loop do
        ws.send STDIN.gets.strip
      end
    end
    threads << t
  end

  threads.each { |t| t.join }
end


#cronから毎分起動。
lockfile = "/var/lock/mukoyama/sakura_tmpr.pid"
if File.exist?(lockfile)
  #ロックファイルが存在するとき
  open(lockfile) do |f|
    pid = f.read
    if process_exist?(pid)
      #ロックファイルに書かれたPIDが存在するならプログラム終了
      puts "This program is already active."
      exit
    else
      #ロックファイルに書かれたPIDが存在しないならロックファイルを更新してget_tmpr実行
      puts "This program might have aborted. execute get_tmpr()."
      FileUtils.rm(lockfile)
      open(lockfile, "w") do |fw|
        fw.puts $$
      end
      get_tmpr
    end
  end
else
  #ロックファイルがなければロックファイルにPIDを書き出してget_tmpr実行
  open(lockfile, "w") do|f|
    f.puts $$
    get_tmpr
  end
end
