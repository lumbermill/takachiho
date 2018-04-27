#! /usr/local/bin/ruby
# 閾値を超えているかチェックする
require 'time'
require 'twilio-ruby'
require 'uri'

class TmprCheck
  include ApplicationHelper

  def self.execute
    helper = ApplicationController.helpers
    Device.all.each do |setting|
      log = Temp.where(device_id: setting.id).order(:updated_at).last
      next if log.nil?
      now = Time.now
      print "device_id:#{setting.id} ts:#{log.updated_at} temp: #{log.temperature}"
      msg = "#{now.hour}時#{now.min}分 #{setting.name} "
      addresses = Address.where(device_id: setting.id, active: true)
      if log.updated_at < now - Mailer::MAX_DELAY.minute
        puts " [too old]"
        msg += "データの受信を確認できません。最終受信日時は、#{log.updated_at.hour}時#{log.updated_at.min}分です。"
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
        helper.send_message(addresses, msg, true)
      end
    end
  end
end

TmprCheck.execute
