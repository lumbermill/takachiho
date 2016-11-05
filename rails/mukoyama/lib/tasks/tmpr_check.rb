#! /usr/local/bin/ruby
# 閾値を超えているかチェックする
require 'time'
require 'twilio-ruby'
require 'uri'

class TmprCheck

  def self.execute
    Setting.all.each do |setting|
      log = TmprLog.where(raspi_id: setting.raspi_id).order(:time_stamp).last
      now = Time.now
      print "raspi_id:#{setting.raspi_id} ts:#{log.time_stamp} temp: #{log.temperature}"
      if setting.max_tmpr < log.temperature
        puts " [over]"
        send_mail(setting.raspi_id, "#{now.hour}時#{now.min}分 #{log.temperature}°Cです。設定を上回りました。")
      elsif setting.min_tmpr > log.temperature
        puts " [below]"
        send_mail(setting.raspi_id, "#{now.hour}時#{now.min}分 #{log.temperature}°Cです。設定を下回りました。")
      else
        puts " [fine]"
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
      print "  #{address.mail}"
      if ts.nil? || ts + address.snooze.minute < now
        d_flg = true
        if address.phone?
          puts " call"
          make_call(address.mail, msg)
        else
          cmd = "echo '#{msg}' | sendmail #{address.mail}"
          puts " sendmail"
          system(cmd)
        end
      else
        puts " snoozed"
      end
      MailLog.create(address_id: address.id, time_stamp: now, delivered: d_flg)
    end
  end

  def self.make_call(number, msg)
    sid = ENV['TWILIO_SID']
    token = ENV['TWILIO_TOKEN']
    twilio_number = ENV['TWILIO_NUMBER']
    url = 'http://twimlets.com/echo?Twiml=%3CResponse%3E%3CSay%20language%3D%22ja-jp%22%20voice%3D%22woman%22%3E'+URI.escape(msg)+'%3C%2FSay%3E%3C%2FResponse%3E'
    unless sid
      puts "  !!Please add environment variables for Twilio.!!"
      puts "  #{url}"
      return
    end
    @client = Twilio::REST::Client.new sid, token
    @client.account.calls.create({
      :to => number,
      :from => twilio_number,
      :method => 'GET',
      :fallback_method => 'GET',
      :status_callback_method => 'GET',
      :record => 'false',
      :url => url})
  end
end

TmprCheck.execute
