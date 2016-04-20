require "#{Rails.root}/app/models/tmpr_logs"
require "#{Rails.root}/app/models/setting"
require "#{Rails.root}/app/models/address"

class TmprCheck

  def self.execute
    if(ARGV[0] == nil || ARGV[0] == "" || ARGV[0].to_i.to_s != ARGV[0].to_s)
      puts "raspberrypiIDを指定してください。"
      return
    end

    id = ARGV[0].to_i
    setting = Setting.where(raspi_id: id)
    tmpr_logs = TmprLog.where(raspi_id: id)
    logs = tmpr_logs.order(:time_stamp).last

    puts logs.temperature
    if setting.first.max_tmpr < logs.temperature
      send_mail(id, "xx時xx分 #{logs.temperature}°Cです。設定値を上回りました。")
    elsif setting.first.min_tmpr > logs.temperature
      send_mail(id, "xx時xx分 #{logs.temperature}°Cです。設定値を下回りました。")
    end
  end

  def self.send_mail(id, msg)
    addresses = Address.where(raspi_id: id)
    addresses.each do |address|
      next if (address.active != true)
      cmd = "echo '#{msg}' | sendmail #{address.mail}"
      puts cmd
      system(cmd)
    end
  end
end

TmprCheck.execute
