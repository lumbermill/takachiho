require 'test_helper'

class TmprMonthlyLogsControllerTest < ActionController::TestCase
  setup do
    @tmpr_monthly_log = tmpr_monthly_logs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tmpr_monthly_logs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tmpr_monthly_log" do
    assert_difference('TmprMonthlyLog.count') do
      post :create, tmpr_monthly_log: { humidity: @tmpr_monthly_log.humidity, pressure: @tmpr_monthly_log.pressure, raspi_id: @tmpr_monthly_log.raspi_id, temperature: @tmpr_monthly_log.temperature, year_month: @tmpr_monthly_log.year_month }
    end

    assert_redirected_to tmpr_monthly_log_path(assigns(:tmpr_monthly_log))
  end

  test "should show tmpr_monthly_log" do
    get :show, id: @tmpr_monthly_log
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @tmpr_monthly_log
    assert_response :success
  end

  test "should update tmpr_monthly_log" do
    patch :update, id: @tmpr_monthly_log, tmpr_monthly_log: { humidity: @tmpr_monthly_log.humidity, pressure: @tmpr_monthly_log.pressure, raspi_id: @tmpr_monthly_log.raspi_id, temperature: @tmpr_monthly_log.temperature, year_month: @tmpr_monthly_log.year_month }
    assert_redirected_to tmpr_monthly_log_path(assigns(:tmpr_monthly_log))
  end

  test "should destroy tmpr_monthly_log" do
    assert_difference('TmprMonthlyLog.count', -1) do
      delete :destroy, id: @tmpr_monthly_log
    end

    assert_redirected_to tmpr_monthly_logs_path
  end
end
