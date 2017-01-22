# ユーザと対話するBot
# ユーザは0個以上の設定を持ちます。
# 副作用(DBの更新)を持つメソッドは debug=trueの時、動作を抑制して単体テストが出来るようにします
class LineBot
  attr_accessor :debug

  def initialize(user_id,settings=[],debug = false)
    @user_id = user_id
    @settings = settings || []
    @debug = debug
  end

  def reply(text)
    if settings.count == 0
      setting = find_raspi_from_message(text)
      if setting.nil?
        return "コードを確認できません。"
      else
        raspi_id = setting.raspi_id
        add_address(@user_id,raspi_id)
        return "コードを確認しました。「#{setting.name}」の通知をお送りします。"
      end
    else
      # TODO: 状態確認と現在値の返答を実装
      if text == "一覧"
      else
        s = find_raspi_from_message(text)
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

  def find_raspi_from_message(text)
    # TODO: 合言葉に該当するraspi_idを検索する、とりあえず今はIDだけでOK
    id = text.split("-")[0].to_i
    s = Setting.find(id)
    return s
  end

end
