#! /usr/local/bin/ruby
# 閾値を超えているかチェックする
require 'time'
require 'twilio-ruby'
require 'uri'

class TmprCheck
  include ApplicationHelper

  def self.execute
    Device.all.each do |setting|
      log = Temp.where(device_id: setting.device_id).order(:time_stamp).last
      next if log.nil?
      now = Time.now
      print "device_id:#{setting.device_id} ts:#{log.time_stamp} temp: #{log.temperature}"
      msg = "#{now.hour}時#{now.min}分 #{setting.name} "
      addresses = Address.where(device_id: setting.device_id,active: true)
      if log.time_stamp < now - Mailer.MAX_DELAY.minute
        puts " [too old]"
        msg += "データの受信を確認できません。最終受信日時は、#{log.time_stamp.hour}時#{log.time_stamp.min}分です。"
      elsif setting.temp_max < log.temperature
        puts " [over]"
        msg += "#{log.temperature}°Cです。設定を上回りました。"
      elsif setting.temp_min > log.temperature
        puts " [below]"
        msg += "#{log.temperature}°Cです。設定を下回りました。"
      else
        puts " [fine]"
        addresses = []
      end
      if addresses.count > 0
        send_message(addresses, msg, true)
      end
    end
  end
end

TmprCheck.execute
