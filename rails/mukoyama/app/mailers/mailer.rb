class Mailer < ApplicationMailer
  def send_mail(to, subject, msg)
    @content = msg
    mail(to: to, subject: subject)
  end

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

  def send_line(user_id,message)
    line_client.push_message(user_id,{type: 'text', text: message})
  end
end
