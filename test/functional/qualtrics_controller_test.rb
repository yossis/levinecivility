require 'test_helper'

class QualtricsControllerTest < ActionController::TestCase
  test "should get see" do
    get :see
    assert_response :success
  end

  test "should get done" do
    get :done
    assert_response :success
  end

end
