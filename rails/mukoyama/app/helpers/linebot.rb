# ユーザと対話するBot
# ユーザは0個以上の設定を持ちます。
# 副作用(DBの更新)を持つメソッドは debug=trueの時、動作を抑制して単体テストが出来るようにします
class Linebot
  attr_accessor :debug

  # 登録 id-tttt, 解除 id-tttt, 一覧

  def self.by_userid(user_id)
    ids = Address.where(mail: user_id, active: true).map{|a| a.raspi_id }
    settings = Setting.where(raspi_id: ids)
    return Linebot.new(user_id,settings)
  end

  def initialize(user_id,settings=[],debug = false)
    @user_id = user_id
    @settings = settings || []
    @cities = []
    @settings.each { |s| @cities += [s.city_id] if s.city_id }
    @debug = debug
    @img_url = 404
  end

  def reply(text)
    if @settings.count == 0 || text.start_with?(*["登録","追加"]) || text.end_with?(*["を追加","を追加して","を登録","を登録して"])
      setting = find_new_raspi_from_message(text)
      if setting.nil?
        return "コードを確認できません。センサを登録してください。"
      else
        add_address(@user_id,setting.raspi_id)
        return "コードを確認しました。「#{setting.name}」の通知をお送りします。"
      end
    elsif text.start_with?("解除")
      setting = find_new_raspi_from_message(text)
      if setting.nil?
        return "コードを確認できません。"
      else
        remove_address(@user_id,setting.raspi_id)
        return "コードを確認しました。「#{setting.name}」からの通知を解除します。"
      end
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
          tl = TmprLog.where(raspi_id: s.raspi_id).order("time_stamp desc").limit(1).first
          return "データが見つかりませんでした。" if tl.nil?
          ts = tl.time_stamp.strftime("%H時%M分")
          if has_new_image(s.raspi_id)
            # 画像があれば、URLをセット
            @img_url = get_latest_image(s.raspi_id)
          end
          if s.city_id
            # 天気情報があれば追記
            w = reply_about_weather(s.city_id)
          else
            w = ""
          end
          return "#{ts} 「#{s.name}」気温#{tl.temperature}、湿度#{tl.humidity}%です。" + w
        end
      end
    end
  end

  def reply_about_weather(city_id)
    name = Setting.new(city_id: city_id).city_name
    weather = Linebot::get_weather(city_id)
    if weather
      case weather["weather_main"]
      when "Rain" then
        w = "雨"
      when "Cloud" then
        w = "曇り"
      else
        w = weather["weather_main"]
      end

      temp = weather["temp"]
      return "#{name}の天気は#{w}、気温は#{temp}度です。"
    else
      return "#{name}の天気情報を取得できません。"
    end
  end

  def reply_help
    'センサの「登録」「一覧」「解除」は、そのように話しかけてください。'
  end

  def add_address(user_id,raspi_id)
    # Register
    address = Address.find_by(raspi_id: raspi_id, mail: user_id)
    if address
      address.active = true
      address.save
    else
      Address.create(raspi_id: raspi_id, mail: user_id, active: true)
    end
  end

  def remove_address(user_id,raspi_id)
    # Remove
    address = Address.find_by(raspi_id: raspi_id, mail: user_id)
    if address
      address.active = false
      address.save
    end
  end

  def find_my_raspi_from_message(text)
    @settings.each do |s|
      return s if text.include? s.name
    end
    return nil
  end

  def find_new_raspi_from_message(text)
    m = text.match /[0-9]+-[0-9a-f]{4}/  # id-tttt (4 letters of token)
    return nil if m.nil?
    id = m[0].split("-")[0].to_i
    s = Setting.find_by(raspi_id: id)
    return nil if s.nil?
    # TODO: 合言葉に該当するraspi_idを検索する、とりあえず今はIDだけでOK
    return s
  end

  # Within 30 minutes.
  def has_new_image(raspi_id)
    flg = false
    dir = PicturesController::BASEDIR+"/#{raspi_id}"
    return false unless File.directory? dir
    count = 0
    Dir.entries(dir).sort.reverse.each do |f|
      break if count > 3 # 30分間（画像3枚分）の確認が終わったらループを抜ける
      next if f.start_with? "."
      next unless f.end_with? ".jpg"
      count += 1
      # 現在時刻と30分前の時間を取得
      t = Time.now
      t_30m_ago = t - 30 * 60
      # 分の1桁目取得
      first_digit = t_30m_ago.min.abs.to_s.each_byte.map{|b| b - 0x30}[-1]
      t_truncate = Time.at(t_30m_ago.to_i / 60 * 60) - first_digit * 60
      # 現在の日付と30分前の日付のファイル以外はスキップ
      next unless f.start_with?(*[t.strftime("%y%m%d"),t_truncate.strftime("%y%m%d")])
      # 170217_012001.jpg
      # 30分前の時刻 ~ 現在時刻までのファイルを取得
      if (f.split("_")[0] == t_30m_ago.strftime("%y%m%d") && f.split("_")[1].split(".")[0].to_i >= t_30m_ago.strftime("%H%M00").to_i) ||
          (f.split("_")[0] == t.strftime("%y%m%d") && f.split("_")[1].split(".")[0].to_i < t.strftime("%H%M00").to_i)
        flg = true
      end
    end
    return flg
  end

  def get_latest_image(raspi_id)
    dir = PicturesController::BASEDIR+"/#{raspi_id}"
    return "画像が登録されていません。" unless File.directory? dir
    setting = Setting.find(raspi_id)
    return "画像が公開されていません。" unless setting.readable?
    Dir.entries(dir).sort.reverse.each do |f|
      next if f.start_with? "."
      next unless f.end_with? ".jpg"
      return "https://mukoyama.lmlab.net/pictures/#{raspi_id}/#{f}?token=#{setting.token4read}"
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
