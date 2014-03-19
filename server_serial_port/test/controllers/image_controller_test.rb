require 'test_helper'

class ImageControllerTest < ActionController::TestCase
  test "should get load" do
    get :load
    assert_response :success
  end

  test "should get save" do
    get :save
    assert_response :success
  end

  test "should get manipulation" do
    get :manipulation
    assert_response :success
  end

end
