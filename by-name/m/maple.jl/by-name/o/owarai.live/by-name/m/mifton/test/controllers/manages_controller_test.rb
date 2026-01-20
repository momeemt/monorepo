require 'test_helper'

class ManagesControllerTest < ActionDispatch::IntegrationTest
  test "should get debug" do
    get manages_debug_url
    assert_response :success
  end

end
