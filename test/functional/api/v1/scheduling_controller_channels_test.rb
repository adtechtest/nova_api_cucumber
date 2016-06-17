require 'test_helper'

class Api::V1::SchedulingControllerTest < ActionController::TestCase
  test "get channels" do
    get(:channels, {'date' => '2016-08-01'})
    body = JSON.parse(response.body)
    channels = body["channels"]
    channels2 = Channel.where(valid_to: nil)
    assert_equal 0, body["status"]
    assert_equal channels.size, channels2.size
  end
end
