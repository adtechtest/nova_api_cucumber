require 'test_helper'

class Api::V1::SchedulingControllerTest < ActionController::TestCase
  self.use_transactional_fixtures = false

  test "get signature captions" do
    channel_code = 'ZT'
    date = '2020-01-01'

    get(:signature_captions, {'channel_code' => channel_code, 'date' => date})
    body = JSON.parse(response.body)
    assert_equal 0, body["status"]
  end
end
