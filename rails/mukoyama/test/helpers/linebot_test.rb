require 'test_helper'

# bin/rake test TEST='test/helpers/linebot_test.rb'
class LinebotTest < ActionController::TestCase
  test "register to linebot" do
    bot = Linebot.by_userid('dummy-userid')
    assert_nil Address.find_by(mail: 'dummy-userid')
    assert_equal "コードを確認できません。", bot.reply('invalid message')
    assert_equal "コードを確認しました。「test2」の通知をお送りします。", bot.reply('2-asdf')
    assert_equal 1, Address.where(mail: 'dummy-userid').count
  end

  test "ask to linebot" do
    bot = Linebot.new('dummy-userid',Setting.where(raspi_id: 2))
    assert_equal "今日も良い天気ですね。", bot.reply('こんにちは')
    assert_equal "xx時xx分 「test2」気温4.5、湿度45%です。", bot.reply('今test2どんな？')
  end

end
