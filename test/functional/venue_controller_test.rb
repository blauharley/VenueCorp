require 'test_helper'

class VenueControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

end
