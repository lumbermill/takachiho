class PagesController < ApplicationController
  protect_from_forgery :except => [:linebot]

  include ApplicationHelper # for format_timestamp method.
  include ActionView::Helpers::DateHelper

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
    sql = "SELECT count(1) AS n_temps, min(dt) AS first, max(dt) AS last FROM temps WHERE device_id = #{id}"
    h = conn.select_one(sql).to_hash
    h["device_id"] = id
    latest = Device.find(id).temps.order("id desc").first
    if latest
      fnames = [:temperature, :pressure, :humidity, :illuminance, :voltage]
      fnames.each do |n|
        h[n] = latest[n] || "-"
      end
    end
    # Append stats of pictures
    sql = "SELECT count(1) AS n_pictures, min(dt) AS first, max(dt) AS last FROM pictures WHERE device_id = #{id}"
    hp = conn.select_one(sql).to_hash
    h["n_pictures"] = hp["n_pictures"] || 0
    h["ago"] = time_ago_in_words([h["last"],hp["last"]].compact.max)
    h["first"] = format_timestamp(h["first"])
    h["last"] = format_timestamp(h["last"])

    render text: h.to_json
  end

  def dashboard_stat2
    if current_user.admin?
      @devices = Device.all.order("id")
    else
      @devices = Device.where(user_id: current_user.id).order("id")
    end

    h = {}
    h["disk_usage"] = @devices.map{|d| d.pictures.sum("length(data)")}.sum
    render text: h.to_json
  end

  def dashboard_mail_logs
    @mail_logs = Notification.order("ts desc,address_id desc").limit(100)
    render layout: false
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
    @cities = Mukoyama::CITY_IDS.invert
    @datetime = nil
    @weathers = @cities.keys.map do |city_id|
      w = Weather.where(id: city_id).order("dt desc").first
      if w
        @datetime ||= w.dt
        @datetime = [@datetime, w.dt].max
      end
      w
    end
    @weathers.delete(nil)
    @datetime = "No record found." unless @datetime
  end

  def weather4city
    @city_id = params[:city_id]
    city_name = Mukoyama::CITY_IDS.invert[@city_id.to_i]
    city_name_jp = Mukoyama::CITY_NAMES[city_name]
    @city_name = "#{city_name_jp}(#{city_name})"
    @weathers = Weather.where(id: @city_id).order("dt desc").limit(100)
  end

  # Show markdown content.
  def doc
    name = params[:name]
    f = "#{Rails.root}/assets/#{name}.md"
    raise 'Page not found' unless File.file? f
    require 'redcarpet'
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, extensions = {fenced_code_blocks: true})
    @headers = []
    File.open(f).readlines.each do |line|
      next unless line.start_with? "#"
      @headers += [line.strip.sub(/^#+ +/,'')]
    end
    fh = File.open(f)
    fh.readline
    @body = markdown.render(fh.read).html_safe
  end

  def howto
    @histories = []
    File.open("#{Rails.root}/assets/histories.md").each do |line|
      next unless line.start_with? "- "
      @histories += [line.sub("- ","")]
    end
  end
end
