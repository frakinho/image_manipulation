require 'test_helper'

class LendingControllerTest < ActionController::TestCase
  test "should get user_id:integer" do
    get :user_id:integer
    assert_response :success
  end

  test "should get book_id:integer" do
    get :book_id:integer
    assert_response :success
  end

  test "should get size_widht:float" do
    get :size_widht:float
    assert_response :success
  end

  test "should get size_height:float" do
    get :size_height:float
    assert_response :success
  end

  test "should get weight:float" do
    get :weight:float
    assert_response :success
  end

end
