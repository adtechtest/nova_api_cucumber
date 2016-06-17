require 'test_helper'

class Api::V1::SchedulingControllerTest < ActionController::TestCase
  test "import schedule" do
    channel_code = 'ZT'
    date = '2016-01-01'
    json_data = File.read('data/schedule3.json')

    post(:import_schedule, {'date' => date, 'channel_code' => channel_code, 'json' => json_data})
    assert_response :success
    body = JSON.parse(response.body)
    assert_equal 0, body["status"]

    json = JSON.parse(json_data)
    json.each do |daypart, maps|
      win_label = daypart
      sig_to_count_map = {}
      maps.each do |map|
        signature = map['signature']
        break_count = sig_to_count_map[signature].blank? ? 1 : sig_to_count_map[signature]+1
        sig_to_count_map[signature] = break_count

        records = SchMatrixBreak.where(SCH_DATE: date, CHANNEL_CODE: channel_code, 
          SIGNATURE: signature, DAY_PART: daypart, MASTER_BREAK_NUM: break_count)
        assert_equal 1, records.size
        city_maps = map["cities"]
        id = records.first["ID"]
        city_maps.each do |city_map|
          captions = city_map['captions']
          city_code = city_map['code']
          seq_in_break = 1
          captions.each do |caption|
            ad_name = caption['ad_name']
            caption_id = caption['id']
            duration = caption['duration']
            caption_name = caption['name']
            records = SchMatrixLocalAd.where(SCH_MATRIX_BRK_ID: id, CITY_CODE: city_code, SEQ_IN_BREAK: seq_in_break, 
              CAPTION_ID: caption_id, AD_NAME: ad_name, CAPTION_NAME: caption_name, SCHEDULED_DURATION: duration)
            assert_equal 1, records.size
            seq_in_break = seq_in_break+1
          end
        end
      end
    end
  end
end
