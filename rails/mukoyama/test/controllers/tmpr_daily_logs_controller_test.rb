require 'test_helper'

class TmprDailyLogsControllerTest < ActionController::TestCase
  setup do
    @tmpr_daily_log = tmpr_daily_logs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tmpr_daily_logs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tmpr_daily_log" do
    assert_difference('TmprDailyLog.count') do
      post :create, tmpr_daily_log: { humidity: @tmpr_daily_log.humidity, pressure: @tmpr_daily_log.pressure, raspi_id: @tmpr_daily_log.raspi_id, temperature: @tmpr_daily_log.temperature, time_stamp: @tmpr_daily_log.time_stamp }
    end

    assert_redirected_to tmpr_daily_log_path(assigns(:tmpr_daily_log))
  end

  test "should show tmpr_daily_log" do
    get :show, id: @tmpr_daily_log
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @tmpr_daily_log
    assert_response :success
  end

  test "should update tmpr_daily_log" do
    patch :update, id: @tmpr_daily_log, tmpr_daily_log: { humidity: @tmpr_daily_log.humidity, pressure: @tmpr_daily_log.pressure, raspi_id: @tmpr_daily_log.raspi_id, temperature: @tmpr_daily_log.temperature, time_stamp: @tmpr_daily_log.time_stamp }
    assert_redirected_to tmpr_daily_log_path(assigns(:tmpr_daily_log))
  end

  test "should destroy tmpr_daily_log" do
    assert_difference('TmprDailyLog.count', -1) do
      delete :destroy, id: @tmpr_daily_log
    end

    assert_redirected_to tmpr_daily_logs_path
  end
end
