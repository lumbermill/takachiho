require 'test_helper'

class TimezoneTest < ActionDispatch::IntegrationTest
  test 'timezone' do
    conn = ActiveRecord::Base.connection
    # conn.execute("set global time_zone = '+09:00'") # doesn't work
    # 直接SQLを投げる場合は、UTC指定(日本時間から9時間マイナス)で
    sql = "insert into temps (device_id,dt,created_at,updated_at) values (3,'2017-07-05 00:37:37',now(),now())"
    conn.execute(sql)
    sql = "select * from temps where device_id = 3"
    results = conn.select_all(sql)
    row = results.to_a[0]
    t = Temp.find_by(device_id: 3)
    # 内部的な値は一緒
    assert_equal row["dt"].to_i, t.dt.to_i
    assert_equal row["created_at"].to_i, t.created_at.to_i
    assert_equal row["updated_at"].to_i, t.updated_at.to_i
    # Time型を使う場合は、タイムゾーンを明示(しないとUTCで表示される)
    assert_equal "2017-07-05 09:37:37 +0900", row["dt"].localtime('+09:00').to_s
    assert_equal "2017-07-05 09:37:37 +0900", t.dt.to_s

    # リテラルで指定する場合もタイムゾーンを明示
    t.dt = DateTime.parse("2017-07-05T11:45:45+09:00")
    t.created_at = DateTime.now
    t.save

    sql = "select * from temps where device_id = 3"
    results = conn.select_all(sql)
    row = results.to_a[0]
    assert_equal "2017-07-05 11:45:45 +0900", row["dt"].localtime('+09:00').to_s
    assert_equal "2017-07-05 11:45:45 +0900", t.dt.to_s

    assert_equal row["created_at"].localtime('+09:00').to_s, t.created_at.to_s
  end
end
