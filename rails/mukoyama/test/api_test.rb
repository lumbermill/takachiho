require 'test_helper'

class APITest < ActionDispatch::IntegrationTest
  test "temps/upload" do
    get '/temps/upload'
    assert_response :missing
    get '/temps/upload', {id:1, token:'123456'}
    assert_response :error
    get '/temps/upload', {id:1, token:'123456', dt: '2017-07-05T00:37:37+09:00' ,temperature:1, pressure:2, humidity:3, illuminance:4, voltage:5}
    # puts response.body
    assert_response :success
    # データベースに格納されたことを確認
    t = Temp.last
    assert_equal('2017-07-05 00:37:37 +0900', t.dt.to_s)
    assert_equal(1, t.temperature)
    assert_equal(2, t.pressure)
    assert_equal(3, t.humidity)
    assert_equal(4, t.illuminance)
    assert_equal(5, t.voltage)
  end

  test "pictures/upload" do
    get '/pictures/upload'
    assert_response :missing
    post '/pictures/upload', {id:1, token:'123456'}
    assert_response :error
    f = File.open('app/assets/images/about.png','rb')
    post '/pictures/upload', {id:1, token:'123456', dt: '2017-07-05T00:37:37+09:00', data: f.read , data_type: 'image/jpeg', detected: true, info: "{foo: bar}"}
    assert_response :success

    # データベースに格納されたことを確認
    p = Picture.last
    assert_equal f.size, p.data.length
    assert_equal 'image/jpeg', p.data_type
    assert p.detected
    assert_equal "{foo: bar}", p.info

    # 認証なしではアクセスできない
    get "/pictures/#{p.id}"
    assert_response :redirect

    # アクセス可能な場合 TODO: tokenがあれば簡単に見える…
    d = p.device
    d.token4read = '123456'
    d.save
    get "/pictures/#{p.id}"
    assert_equal f.size, response.content_length
    assert_response :success
  end

  test "devices/id/publish" do
    # TODO: 認証エリアのテストはどうする？今はここで落ちてしまう
    get '/devices/1/publish'
    assert_response :success
  end
end
