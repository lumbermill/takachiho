require 'test_helper'

class DevicesControllerTest < ActionController::TestCase
  setup do
    @setting = settings(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:settings)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create setting" do
    assert_difference('Device.count') do
      post :create, setting: { max_tmpr: @setting.max_tmpr, min_tmpr: @setting.min_tmpr, device_id: @setting.device_id }
    end

    assert_redirected_to device_path(assigns(:setting))
  end

  test "should show setting" do
    get :show, id: @setting
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @setting
    assert_response :success
  end

  test "should update setting" do
    patch :update, id: @setting, setting: { max_tmpr: @setting.max_tmpr, min_tmpr: @setting.min_tmpr, device_id: @setting.device_id }
    assert_redirected_to device_path(assigns(:setting))
  end

  test "should destroy setting" do
    assert_difference('Device.count', -1) do
      delete :destroy, id: @setting
    end

    assert_redirected_to settings_path
  end
end
