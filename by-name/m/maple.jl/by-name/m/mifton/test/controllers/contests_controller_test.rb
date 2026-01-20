require 'test_helper'

class ContestsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get contests_index_url
    assert_response :success
  end

  test "should get show" do
    get contests_show_url
    assert_response :success
  end

  test "should get new" do
    get contests_new_url
    assert_response :success
  end

end
