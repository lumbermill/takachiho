require 'rubygems'
require 'websocket-client-simple'
require 'json'

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
