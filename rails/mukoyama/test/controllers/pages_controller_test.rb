require 'test_helper'

class PagesControllerTest < ActionController::TestCase
  test "should get root" do
    get :root
    assert_response :success
  end

  test "should get about" do
    get :about
    assert_response :success
  end

end
