# ユーザと対話するBot
# ユーザは0個以上の設定を持ちます。
# 副作用(DBの更新)を持つメソッドは debug=trueの時、動作を抑制して単体テストが出来るようにします
class Linebot
  attr_accessor :debug

  # 登録 id-tttt, 解除 id-tttt, 一覧

  def self.by_userid(user_id)
    ids = Address.where(address: user_id, active: true).map{|a| a.device_id }
    settings = Device.where(id: ids)
    return Linebot.new(user_id,settings)
  end

  def initialize(user_id,settings=[],debug = false)
    @user_id = user_id
    @settings = settings || []
    @cities = []
    @settings.each { |s| @cities += [s.city_id] if s.city_id }
    @debug = debug
    @img_url = "404"
  end

  def reply(text)
    if @settings.count == 0 || text.start_with?(*["登録","追加"]) || text.end_with?(*["を追加","を追加して","を登録","を登録して"])
      setting = find_new_raspi_from_message(text)
      if setting.nil?
        return "コードを確認できません。センサを登録してください。"
      else
        add_address(@user_id,setting.id)
        return "コードを確認しました。「#{setting.name}」の通知をお送りします。"
      end
    elsif text.start_with?("解除")
      setting = find_new_raspi_from_message(text)
      if setting.nil?
        return "コードを確認できません。"
      else
        remove_address(@user_id,setting.id)
        return "コードを確認しました。「#{setting.name}」からの通知を解除します。"
      end
    elsif text.include?("天気") && (city_id = Linebot::find_city_id_from_message(text)) != nil
      return reply_about_weather(city_id)
    else
      if text == "一覧"
        m = ""
        @settings.each do |s|
          m += "#{s.id}-0000 #{s.name} #{s.city_name}\n"
        end
        return m
      else
        s = find_my_raspi_from_message(text)
        if s.nil?
          # 適当な街があれば天気情報を返す
          # なければヘルプメッセージ
          city_id = @cities.shuffle[0]
          return reply_about_weather(city_id) if city_id
          return reply_help
        else
          tl = Temp.where(device_id: s.id).order("time_stamp desc").limit(1).first
          if has_new_image(s.id)
            # 画像があれば、URLをセット
            @img_url = get_latest_image(s.id)
          end
          if s.city_id
            # 天気情報があれば追記
            w = reply_about_weather(s.city_id)
          else
            w = ""
          end
          return "温度データが見つかりませんでした。" + w if tl.nil?
          ts = tl.time_stamp.strftime("%H時%M分")
          return "#{ts} 「#{s.name}」気温#{tl.temperature}、湿度#{tl.humidity}%です。" + w
        end
      end
    end
  end

  WEATHER_JP = {"Clear" => "晴れ", "Clouds" => "曇り", "Rain" => "雨", "Snow" => "雪", "Thunderstorm" => "雷雨", "Fog" => "霧"}

  def reply_about_weather(city_id)
    name = Device.new(city_id: city_id).city_name
    weather = Linebot::get_weather(city_id)
    if weather
      w = WEATHER_JP[weather["weather_main"]]
      w = weather["weather_main"] if w.nil?
      temp = weather["temp"]
      return "#{name}の天気は#{w}、気温は#{temp}度です。"
    else
      return "#{name}の天気情報を取得できません。"
    end
  end

  def reply_help
    'センサの「登録」「一覧」「解除」は、そのように話しかけてください。'
  end

  def add_address(user_id,device_id)
    # Register
    address = Address.find_by(device_id: device_id, mail: user_id)
    if address
      address.active = true
      address.save
    else
      Address.create(device_id: device_id, mail: user_id, active: true)
    end
  end

  def remove_address(user_id,device_id)
    # Remove
    address = Address.find_by(device_id: device_id, mail: user_id)
    if address
      address.active = false
      address.save
    end
  end

  def self.find_city_id_from_message(text)
    sql = "select id,name,name_jp from weathers_cities"
    results = ActiveRecord::Base.connection.select_all(sql)
    return nil if results.length == 0
    results.to_a.each do |row|
      name_jp = row["name_jp"].sub("市","") # 四日市は？まあいい？
      return row["id"] if !name_jp.empty? && text.include?(name_jp)
      return row["id"] if !row["name"].empty? && text.include?(row["name"])
    end
    return nil
  end

  def find_my_raspi_from_message(text)
    @settings.each do |s|
      return s if text.include? s.name
    end
    return find_new_raspi_from_message(text)
  end

  def find_new_raspi_from_message(text)
    m = text.match /[0-9]+-[0-9a-f]{4}/  # id-tttt (4 letters of token)
    return nil if m.nil?
    id = m[0].split("-")[0].to_i
    s = Device.find(id)
    return nil if s.nil?
    # TODO: 合言葉に該当するdevice_idを検索する、とりあえず今はIDだけでOK
    return s
  end

  # Within 30 minutes.
  def has_new_image(device_id)
    pic = Picture.where("device_id = ? and dt > date_add(now(),interval -30 minute)", device_id).count
    return pic > 0
  end

  def get_latest_image(device_id)
    pic = Picture.where("device_id = ?", device_id).order("dt desc").first
    return "画像が登録されていません。" unless pic
    setting = Device.find(device_id)
    return "画像が公開されていません。" unless setting.readable?
    Dir.entries(dir).sort.reverse.each do |f|
      next if f.start_with? "."
      next unless f.end_with? ".jpg"
      return "https://mukoyama.lmlab.net/pictures/#{pic.id}?token=#{setting.token4read}"
    end
  end

  # pop latest image url or messages.
  def imgurl
    i = @img_url
    @img_url = nil
    return i
  end

  def userid
    @user_id
  end

  # 指定された地点(city_id)、時刻の天気をハッシュで返します。
  # ex. {"dt"=>2017-02-14 09:00:00 UTC, "id"=>1848373, "weather_main"=>"Clear",
  #      "weather_desc"=>"sky is clear", "temp"=>4.03, "pressure"=>1035.61, "humidity"=>100, "wind_speed"=>0.97,
  #      "wind_deg"=>358.504, "cloudiness"=>0, "rain"=>0.0, "snow"=>nil, "modified_at"=>2017-02-13 21:01:39 UTC}
  def self.get_weather(city_id,ts=nil)
    raise 'city_id can not be nil.' if city_id.nil?
    ts = Time.now if ts.nil?
    t = ts.strftime("%Y-%m-%d %H:%M:%S")
    sql = "select * from weathers where id = #{city_id} and dt <= '#{t}' order by dt desc limit 1"
    results = ActiveRecord::Base.connection.select_all(sql)
    return nil if results.length == 0
    return results.to_a[0]
  end
end
