require 'test_helper'

class Api::V1::SchedulingControllerTest < ActionController::TestCase
  test "import schedule" do
    channel_code = 'IB'
    date = '2015-05-01'
    json_data = File.read('data/schedule1.json')
    
    post(:import_schedule, {'date' => date, 'channel_code' => channel_code, 'json' => json_data})
    assert_response :success
    body = JSON.parse(response.body)
    assert_equal 0, body["status"]
  end

  test "import schedule with invalid daypart" do
    channel_code = 'IB'
    date = '2015-05-01'
    json_data = File.read('data/schedule_invalid_dp.json')
    
    post(:import_schedule, {'date' => date, 'channel_code' => channel_code, 'json' => json_data})
    assert_response :success
    body = JSON.parse(response.body)
    assert_equal 1, body["status"]
  end
end
