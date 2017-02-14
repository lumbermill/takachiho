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
    @debug = debug
  end

  def reply(text)
    if @settings.count == 0 || text.start_with?("登録")
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
          m += "#{s.id}-0000 #{s.name}\n"
        end
        return m
      else
        s = find_my_raspi_from_message(text)
        if s.nil?
          city_id = @settings[0].city_id
          if city_id
            weather = get_weather(city_id)
            if weather
              return weather["weather_main"]
            end
          end
          return 'こんにちは。'
        else
          # TODO: 画像があれば画像を返す
          tl = TmprLog.where(raspi_id: s.raspi_id).order("time_stamp desc").limit(1).first
          return "データが見つかりませんでした。" if tl.nil?
          ts = tl.time_stamp.strftime("%H時%M分")
          return "#{ts} 「#{s.name}」気温#{tl.temperature}、湿度#{tl.humidity}%です。"
        end
      end
    end
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

end

# 指定された地点(city_id)、時刻の天気をハッシュで返します。
# ex. {"dt"=>2017-02-14 09:00:00 UTC, "id"=>1848373, "weather_main"=>"Clear",
#      "weather_desc"=>"sky is clear", "temp"=>4.03, "pressure"=>1035.61, "humidity"=>100, "wind_speed"=>0.97,
#      "wind_deg"=>358.504, "cloudiness"=>0, "rain"=>0.0, "snow"=>nil, "modified_at"=>2017-02-13 21:01:39 UTC}
def get_weather(city_id,ts=nil)
  raise 'city_id can not be nil.' if city_id.nil?
  ts = Time.now if ts.nil?
  t = ts.strftime("%Y-%m-%d %H:%M:%S")
  sql = "select * from weathers where id = #{city_id} and dt <= '#{t}' order by dt desc limit 1"
  results = ActiveRecord::Base.connection.select_all(sql)
  return nil if results.length == 0
  return results.to_a[0]
end
