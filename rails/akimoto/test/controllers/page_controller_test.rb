require 'test_helper'

class PageControllerTest < ActionController::TestCase
  test "should get root" do
    get :root
    assert_response :success
  end

  test "should get howto" do
    get :howto
    assert_response :success
  end

end
