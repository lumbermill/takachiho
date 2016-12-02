class PagesController < ApplicationController
  protect_from_forgery :except => [:linebot]

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

  def dashboard_mail_logs
    @mail_logs = MailLog.order("time_stamp desc,address_id desc").limit(10)
    render layout: false
  end

  def usecase
  end

  def line_client
    require 'line/bot'
    @line_client ||= Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }
  end

  def linebot
    body = request.body.read

    signature = request.headers['HTTP_X_LINE_SIGNATURE']
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
            text: 'Rails: '+event.message['text']
          }
          # TODO: 登録済みのセンサがある場合、現在の温度を返す。
          raspi_id = find_raspi_from_message(event.message['text'])
          if raspi_id.nil?
            line_client.reply_message(event['replyToken'],{type: 'text', text: '合言葉をどうぞ。'})
          else
            # TODO: ユニークのチェックが必要
            Address.create(raspi_id: raspi_id, mail: event['source']['userId'], active: true)
            line_client.reply_message(event['replyToken'],{type: 'text', text: '登録しました。'})
          end
          #client.push_message(,message)
        end
      end
    }

    render plain: "OK"
  end

  private
    def find_raspi_from_message(text)
      # TODO: 合言葉に該当するraspi_idを検索する
      return 1
    end
end
