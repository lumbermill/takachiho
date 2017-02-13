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
    bot = Linebot.new('dummy-userid',Setting.where(raspi_id: 2))
    assert_equal "今日も良い天気ですね。", bot.reply('こんにちは')
    tl = TmprLog.where(raspi_id: 2).order("time_stamp desc").limit(1).first
    assert_equal "10時42分 「test2」気温3.5、湿度90.5%です。", bot.reply('今test2どんな？')

    TmprLog.destroy_all
    assert_equal "データが見つかりませんでした。", bot.reply('今test2どんな？')

    assert_equal "298486374-0000 test2\n", bot.reply('一覧')
  end

end
