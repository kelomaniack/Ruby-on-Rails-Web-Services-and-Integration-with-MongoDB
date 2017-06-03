require 'test_helper'

class HelloControllerTest < ActionController::TestCase
  test "should get sayhello" do
    get :sayhello
    assert_response :success
  end

  test "should get all" do
    get :all
    assert_response :success
  end

end
