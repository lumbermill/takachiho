require 'test_helper'

class PagesControllerTest < ActionController::TestCase
  test "should get root" do
#    get :root
#    assert_response :success
  end

  test "should get about" do
#    get :about
#    assert_response :success
  end

  test "dashboard_stat1" do
    get :dashboard_stat1, {"device_id": 1}
    assert_response :success
    json = JSON.parse(response.body)
    assert_equal "1", json["device_id"]
  end
end
