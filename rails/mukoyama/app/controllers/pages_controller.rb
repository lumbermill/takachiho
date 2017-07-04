class PagesController < ApplicationController
  protect_from_forgery :except => [:linebot]

  include ApplicationHelper # for format_timestamp method.

  def root
    render layout: 'root'
  end

  def dashboard
    if current_user.admin?
      @devices = Device.all.order("id")
      @all = true
    else
      @devices = Device.where(user_id: current_user.id).order("id")
      @all = false
    end
  end

  def dashboard_stat1
    conn = ActiveRecord::Base.connection
    id = params[:device_id]
    sql = "SELECT count(1) AS c, min(time_stamp) AS first, max(time_stamp) AS last FROM tmpr_logs WHERE device_id = #{id}"
    h = conn.select_one(sql).to_hash
    h["device_id"] = id
    h["first"] = format_timestamp(h["first"])
    h["last"] = format_timestamp(h["last"])
    render text: h.to_json
  end

  def dashboard_mail_logs
    @mail_logs = MailLog.order("time_stamp desc,address_id desc").limit(100)
    render layout: false
  end

  def dashboard_pictures
    id = params[:device_id]
    dir = PicturesController::BASEDIR+"/#{id}"
    logger.debug(dir)
    h = {"device_id" => id}
    if File.directory? dir
      h["n"] = Dir.entries(dir).count - 2 # Number of pictures
    else
      h["n"] = 0
    end
    render text: h.to_json
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
          bot = Linebot.by_userid(event['source']['userId'])
          t = bot.reply(event.message['text'])
          line_client.reply_message(event['replyToken'],{type: 'text', text: t})
          i = bot.imgurl
          if i.nil?
            # do nothing
          elsif i.start_with?("http")
            # push image
            line_client.push_message(bot.userid, {type: 'image', originalContentUrl: i, previewImageUrl: i})
          else
            # push message
            line_client.push_message(bot.userid, {type: 'text', text: i})
          end
        end
      end
    }

    render plain: "OK"
  end

  def weather
    sql = "select dt,id,weather_main,temp,modified_at from weathers where dt = (select max(dt) from weathers where dt <= now()) order by id"
    @weathers = ActiveRecord::Base.connection.select_all(sql).to_a
    @sql = sql
    @datetime = @weathers.size > 0 ? @weathers[0]["dt"] : "No record found."

    sql = "select id,name from weathers_cities order by id"
    @cities = {}
    ActiveRecord::Base.connection.select_all(sql).to_a.each do |row|
      @cities[row["id"]] = row["name"]
    end
  end
end
