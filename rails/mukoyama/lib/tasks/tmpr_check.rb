#! /usr/local/bin/ruby
# 閾値を超えているかチェックする
require 'time'
require 'twilio-ruby'
require 'uri'

class TmprCheck
  MAX_DELAY = 60

  def self.execute

    Setting.all.each do |setting|
      log = TmprLog.where(raspi_id: setting.raspi_id).order(:time_stamp).last
      now = Time.now
      print "raspi_id:#{setting.raspi_id} ts:#{log.time_stamp} temp: #{log.temperature}"
      msg = "#{now.hour}時#{now.min}分 #{setting.name} "
      addresses = Address.where(raspi_id: setting.raspi_id,active: true)
      if log.time_stamp < now - MAX_DELAY.minute && addresses.count > 0
        puts " [too old]"
        msg += "データの受信を確認できません。最終受信日時は、#{log.time_stamp.hour}時#{log.time_stamp.min}分です。"
      elsif setting.max_tmpr < log.temperature
        puts " [over]"
        msg += "#{log.temperature}°Cです。設定を上回りました。"
      elsif setting.min_tmpr > log.temperature
        puts " [below]"
        msg += "#{log.temperature}°Cです。設定を下回りました。"
      else
        puts " [fine]"
        addresses = []
      end
      if addresses.count > 0
        send_mail(addresses, msg)
      end
    end
  end

  def self.send_mail(addresses, msg)
    now = DateTime.now
    addresses.each do |address|
      next if (address.active != true)
      ts = MailLog.where(address_id: address.id, delivered: true).maximum(:time_stamp)
      d_flg = false
      print "  #{address.mail}"
      if ts.nil? || ts + address.snooze.minute < now
        d_flg = true
        if address.phone?
          puts " call"
          Mailer.make_call(address.mail, msg)
        else
          subject = "mukoyama"
          Mailer.send_mail(address.mail, subject, msg).deliver_now
        end
      else
        puts " snoozed"
      end
      MailLog.create(address_id: address.id, time_stamp: now, delivered: d_flg)
    end
  end
end

TmprCheck.execute
