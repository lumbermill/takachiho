# ユーザと対話するBot
# ユーザは0個以上の設定を持ちます。
# 副作用(DBの更新)を持つメソッドは debug=trueの時、動作を抑制して単体テストが出来るようにします
class Linebot
  attr_accessor :debug

  def self.by_userid(user_id)
    ids = Address.where(mail: user_id).map{|a| a.raspi_id }
    settings = Setting.where(raspi_id: ids)
    return Linebot.new(user_id,settings)
  end

  def initialize(user_id,settings=[],debug = false)
    @user_id = user_id
    @settings = settings || []
    @debug = debug
  end

  def reply(text)
    if @settings.count == 0 || text.start_with?("追加")
      setting = find_new_raspi_from_message(text)
      if setting.nil?
        return "コードを確認できません。センサを登録してください。"
      else
        raspi_id = setting.raspi_id
        add_address(@user_id,raspi_id)
        return "コードを確認しました。「#{setting.name}」の通知をお送りします。"
      end
    else
      if text == "一覧"
        m = ""
        @settings.each do |s|
          m += "#{s.id} #{s.name}\n"
        end
        return m
      else
        s = find_my_raspi_from_message(text)
        if s.nil?
          # TODO: 天気予報と連動した言葉を返す
          return '今日も良い天気ですね。'
        else
          # TODO: 画像があれば画像を返す
          tl = TmprLog.where(raspi_id: raspi_id).order("time_stamp desc").limit(1).first
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
