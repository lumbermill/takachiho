require 'test_helper'

class TrainDataControllerTest < ActionDispatch::IntegrationTest
  setup do
    @train_datum = train_data(:one)
  end

  test "should get index" do
    get train_data_url
    assert_response :success
  end

  test "should get new" do
    get new_train_datum_url
    assert_response :success
  end

  test "should create train_datum" do
    assert_difference('TrainDatum.count') do
      post train_data_url, params: { train_datum: {  } }
    end

    assert_redirected_to train_datum_url(TrainDatum.last)
  end

  test "should show train_datum" do
    get train_datum_url(@train_datum)
    assert_response :success
  end

  test "should get edit" do
    get edit_train_datum_url(@train_datum)
    assert_response :success
  end

  test "should update train_datum" do
    patch train_datum_url(@train_datum), params: { train_datum: {  } }
    assert_redirected_to train_datum_url(@train_datum)
  end

  test "should destroy train_datum" do
    assert_difference('TrainDatum.count', -1) do
      delete train_datum_url(@train_datum)
    end

    assert_redirected_to train_data_url
  end
end
