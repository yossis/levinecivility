require 'test_helper'

class Qualtrics2ControllerTest < ActionController::TestCase
  test "should get from" do
    get :from
    assert_response :success
  end

  test "should get to" do
    get :to
    assert_response :success
  end

end
