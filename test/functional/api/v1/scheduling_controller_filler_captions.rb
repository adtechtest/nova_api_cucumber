require 'test_helper'

class Api::V1::SchedulingControllerTest < ActionController::TestCase
  self.use_transactional_fixtures = false

  test "get filler captions" do
    channel_code = 'ZT'

    filler_captions = FillerCaption.where("CHANNEL_ID = ?", channel_code)
    get(:filler_captions, {'channel_code' => channel_code})
    body = JSON.parse(response.body)
    assert_equal 0, body["status"]
    assert_equal filler_captions.size, body["filler_captions"].size
  end
end
