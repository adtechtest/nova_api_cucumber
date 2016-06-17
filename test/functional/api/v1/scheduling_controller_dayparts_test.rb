require 'test_helper'

class Api::V1::SchedulingControllerTest < ActionController::TestCase
  test "get dayparts" do
    week_thu = '2015-07-02'
    week_fri = '2015-07-03'
    week_sat = '2015-07-04'

    get(:dayparts, {'channel_code' => 'ZC', 'date' => week_thu})
    body_thu = JSON.parse(response.body)
    assert_equal 0, body_thu["status"]
    get(:dayparts, {'channel_code' => 'ZC', 'date' => week_fri})
    body_fri = JSON.parse(response.body)
    assert_equal 0, body_fri["status"]
    get(:dayparts, {'channel_code' => 'ZC', 'date' => week_sat})
    body_sat = JSON.parse(response.body)
    assert_equal 0, body_sat["status"]

    assert_equal body_thu["dayparts"], body_thu["dayparts"]
    assert_not_equal body_thu["dayparts"], body_sat["dayparts"]
  end
end
