require 'test_helper'

# bin/rake test TEST='test/helpers/linebot_test.rb'
class LinebotTest < ActionController::TestCase
  test "register to linebot" do
    bot = Linebot.by_userid('dummy-userid')
    assert_nil Address.find_by(mail: 'dummy-userid')
    assert_equal "コードを確認できません。センサを登録してください。", bot.reply('invalid message')
    assert_equal "コードを確認しました。「test2」の通知をお送りします。", bot.reply('2-01af')
    assert_equal 1, Address.where(mail: 'dummy-userid').count
  end

  test "ask to linebot" do
    bot = Linebot.new('dummy-userid',Device.where(device_id: 2))
    assert_equal "今日も良い天気ですね。", bot.reply('こんにちは')
    tl = Temp.where(device_id: 2).order("time_stamp desc").limit(1).first
    assert_equal "10時42分 「test2」気温3.5、湿度90.5%です。", bot.reply('今test2どんな？')

    Temp.destroy_all
    assert_equal "データが見つかりませんでした。", bot.reply('今test2どんな？')

    assert_equal "298486374-0000 test2\n", bot.reply('一覧')
  end

  test "get weathers" do
    # need to create weathers table on mukoyama_test first.
    assert_raises RuntimeError do
      Linebot::get_weather(nil)
    end
    assert_nil Linebot::get_weather(0)
    assert_equal 1848373, Linebot::get_weather(1848373)["id"] # 四日市
    assert_equal 1856057, Linebot::find_city_id_from_message("天気 名古屋")
    assert_equal 1862588, Linebot::find_city_id_from_message("天気 日之影")
  end

end
