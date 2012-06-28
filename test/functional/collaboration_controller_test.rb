require 'test_helper'

class CollaborationControllerTest < ActionController::TestCase
  test "should get wait" do
    get :wait
    assert_response :success
  end

  test "should get chat" do
    get :chat
    assert_response :success
  end

  test "should get quiz_results" do
    get :quiz_results
    assert_response :success
  end

  test "should get money_decide" do
    get :money_decide
    assert_response :success
  end

  test "should get money_send" do
    get :money_send
    assert_response :success
  end

  test "should get money_results" do
    get :money_results
    assert_response :success
  end

end
