require 'test_helper'

class TempsControllerTest < ActionController::TestCase
  setup do
    @tmpr_log = tmpr_logs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tmpr_logs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tmpr_log" do
    assert_difference('Temp.count') do
      post :create, tmpr_log: { humidity: @tmpr_log.humidity, pressure: @tmpr_log.pressure, device_id: @tmpr_log.device_id, temperature: @tmpr_log.temperature, time_stamp: @tmpr_log.time_stamp }
    end

    assert_redirected_to tmpr_log_path(assigns(:tmpr_log))
  end

  test "should show tmpr_log" do
    get :show, id: @tmpr_log
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @tmpr_log
    assert_response :success
  end

  test "should update tmpr_log" do
    patch :update, id: @tmpr_log, tmpr_log: { humidity: @tmpr_log.humidity, pressure: @tmpr_log.pressure, device_id: @tmpr_log.device_id, temperature: @tmpr_log.temperature, time_stamp: @tmpr_log.time_stamp }
    assert_redirected_to tmpr_log_path(assigns(:tmpr_log))
  end

  test "should destroy tmpr_log" do
    assert_difference('Temp.count', -1) do
      delete :destroy, id: @tmpr_log
    end

    assert_redirected_to tmpr_logs_path
  end
end
