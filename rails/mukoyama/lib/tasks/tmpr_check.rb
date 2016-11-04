#! /usr/local/bin/ruby
# 閾値を超えているかチェックする
require 'time'

class TmprCheck

  def self.execute
    Setting.all.each do |setting|
      log = TmprLog.where(raspi_id: setting.raspi_id).order(:time_stamp).last
      now = Time.now
      puts log.temperature
      if setting.max_tmpr < log.temperature
        send_mail(setting.raspi_id, "#{now.hour}時#{now.min}分 #{log.temperature}°Cです。設定値を上回りました。")
      elsif setting.min_tmpr > log.temperature
        send_mail(setting.raspi_id, "#{now.hour}時#{now.min}分 #{log.temperature}°Cです。設定値を下回りました。")
      end
    end
  end

  def self.send_mail(id, msg)
    addresses = Address.where(raspi_id: id)
    now = DateTime.now
    addresses.each do |address|
      next if (address.active != true)
      ts = MailLog.where(address_id: address.id, delivered: true).maximum(:time_stamp)
      d_flg = false
      if ts.nil? || ts + address.snooze.minute < now
        d_flg = true
        cmd = "echo '#{msg}' | sendmail #{address.mail}"
        puts cmd
        system(cmd)
      end
      MailLog.create(address_id: address.id, time_stamp: now, delivered: d_flg)
    end
  end
end

TmprCheck.execute
