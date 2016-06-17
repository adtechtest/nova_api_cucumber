require 'test_helper'

class Api::V1::SchedulingControllerTest < ActionController::TestCase
  self.use_transactional_fixtures = false

  test "get cities" do
    channel_code = 'ZT'
    date = '2015-01-01'
    get(:cities, {'channel_code' => channel_code, 'date' => date})
    body = JSON.parse(response.body)
    cities = body["cities"]
    assert_equal 0, body["status"]
    assert_not_equal 0, cities.size
  end
end
