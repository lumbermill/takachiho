class Mailer < ApplicationMailer
  # データ不着とみなすまでの遅延時間(分)
  MAX_DELAY = 60

  def send_message(addresses, msg)
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
          make_call(address.mail, msg).deliver_now
        elsif address.mail?
          puts " mail"
          send_mail(address.mail, "Notificaton from Mukoyama", msg).deliver_now
        else
          puts " line"
          send_line(address.mail, msg).deliver_now
        end
      else
        puts " snoozed"
      end
      MailLog.create(address_id: address.id, time_stamp: now, delivered: d_flg)
    end
  end

  def send_mail(to, subject, msg)
    @content = msg
    mail(to: to, subject: subject)
  end

  # make_callは遅延評価されます。
  # このメソッドを呼び出す時はdeliver_now等をつけるようにしてください。
  # 例) Mailer.make_call(number, msg).deliver_now
  def make_call(number, msg)
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

  def line_client
    require 'line/bot'
    @line_client ||= Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }
  end

  # send_lineは遅延評価されます。
  # このメソッドを呼び出す時はdeliver_now等をつけるようにしてください。
  # 例) Mailer.send_line(number, msg).deliver_now
  def send_line(user_id,message)
    line_client.push_message(user_id,{type: 'text', text: message})
  end
end
