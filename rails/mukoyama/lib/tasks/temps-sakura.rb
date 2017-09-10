require 'fileutils'
require 'rubygems'
require 'websocket-client-simple'
require 'json'
require 'optparse'

opt = OptionParser.new
opt.on('--debug') { |v| OPTS[:debug] = true }
opt.on('-e') { |v| OPTS[:env] = v }

OPTS = {}
opt.parse!(ARGV)

def process_exist?(pid)
  cmd = "ps #{pid}"
  `#{cmd}`
  return ($? == 0)
end

def get_tmpr
  Thread.abort_on_exception = true if OPTS[:debug]
  threads = []

  Device.where("token4sakura != ''").each do |d|
    threads << Thread.new do
      url = "wss://api.sakura.io/ws/v1/#{d.token4sakura}"
      puts "id: #{d.id} url: #{url}" if OPTS[:debug]
      ws = WebSocket::Client::Simple.connect url
      ws.on :message do |msg|
        puts "#{d.id}: #{msg}" if OPTS[:debug]
        data = JSON.parse(msg.data)
        next unless data["type"] == "channels"
        tmpr_data = data["payload"]["channels"]
        tmpr_log = Temp.new({device_id: d.id, time_stamp: data["datetime"], temperature: tmpr_data[0]["value"], humidity: tmpr_data[1]["value"], pressure: tmpr_data[2]["value"], sender: data["module"]})
        tmpr_log.save
      end
      puts "id: #{d.id} finished." if OPTS[:debug]
    end
  end

  threads.each { |t| t.join }
  puts "Fin." if OPTS[:debug]
end


#cronから毎分起動。
lockfile = "/var/lock/mukoyama-sakura.pid"
if File.exist?(lockfile)
  #ロックファイルが存在するとき
  open(lockfile) do |f|
    pid = f.read
    if process_exist?(pid)
      #ロックファイルに書かれたPIDが存在するならプログラム終了
      puts "Seems to be running. #{pid}"
      exit
    else
      #ロックファイルに書かれたPIDが存在しないならロックファイルを更新してget_tmpr実行
      puts "Might have aborted. Removing old lockfile."
      FileUtils.rm(lockfile)
    end
  end
end

# ロックファイルにPIDを書き出してget_tmpr実行
open(lockfile, "w") { |fw| fw.puts $$ }
get_tmpr
