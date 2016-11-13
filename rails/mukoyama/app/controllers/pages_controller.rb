class PagesController < ApplicationController
  def root
    render layout: 'root'
  end

  def dashboard
    @raspi_list = Setting.where(user_id: current_user.id).order("id")
  end

  def dashboard_stat1
    conn = ActiveRecord::Base.connection
    id = params[:raspi_id]
    sql = "SELECT count(1) AS c, min(time_stamp) AS first, max(time_stamp) AS last FROM tmpr_logs WHERE raspi_id = #{id}"
    h = conn.select_one(sql).to_hash
    h["raspi_id"] = id
    render text: h.to_json
  end

  def usecase
  end

  def line_client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }
  end

  def linebot
    body = request.body.read

    signature = request.env['HTTP_X_LINE_SIGNATURE']
    unless line_client.validate_signature(body, signature)
      error 400 do 'Bad Request' end
    end

    events = line_client.parse_events_from(body)

    events.each { |event|
      case event
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          message = {
            type: 'text',
            text: event.message['text']
          }
          line_client.reply_message(event['replyToken'], message)
          p event
          #client.push_message(,message)
        end
      end
    }

    "OK"
  end
end
