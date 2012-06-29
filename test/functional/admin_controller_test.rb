require 'test_helper'

class AdminControllerTest < ActionController::TestCase
  test "should get export" do
    get :export
    assert_response :success
  end

end
