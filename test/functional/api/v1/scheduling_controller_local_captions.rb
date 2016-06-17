require 'test_helper'

class Api::V1::SchedulingControllerTest < ActionController::TestCase
  self.use_transactional_fixtures = false

  test "get local captions" do
    channel_code = 'ZT'
    date = '2020-01-01'
    day_part = 'Morning'
    caption_id = 'cap1'
    campaign_id = 'cmp1'
    city_code = 'LD'
    rate = 105

    con = ActiveRecord::Base.connection
    delete_cmp_query = get_delete_campaign_query(campaign_id)
    delete_cap_query = get_delete_caption_query(caption_id)
    delete_rate_query = get_delete_rate_query(caption_id)
    con.execute(delete_cmp_query)
    con.execute(delete_cap_query)
    con.execute(delete_rate_query)

    get(:local_captions, {'channel_code' => channel_code, 'date' => date})
    body = JSON.parse(response.body)
    assert_equal 0, body["status"]
    assert_equal 0, body["captions"].size

    insert_cmp_query = get_insert_campaign_query(campaign_id, date)
    con.execute(insert_cmp_query)
    insert_cap_query = get_insert_caption_query(caption_id, campaign_id)
    con.execute(insert_cap_query)
    insert_rate_query = get_insert_rate_query(caption_id, channel_code, city_code, day_part, rate)
    con.execute(insert_rate_query)

    get(:local_captions, {'channel_code' => channel_code, 'date' => date})
    body = JSON.parse(response.body)
    assert_equal 0, body["status"]
    assert_not_equal 0, body["captions"].size
  end

  def get_insert_campaign_query(campaign_id, valid_till)
    return "insert ignore into AMAGI_REPORTS_DB.ATS_CAMPAIGNS (campaign_id, valid_till) " +
      "values ('#{campaign_id}', '#{valid_till}') on duplicate key update valid_till = '#{valid_till}'"
  end

  def get_insert_caption_query(caption_id, campaign_id)
    return "insert ignore into AMAGI_REPORTS_DB.ATS_CAPTIONS (caption_id, campaign_id) " +
      "values ('#{caption_id}', '#{campaign_id}') on duplicate key update campaign_id = '#{campaign_id}'"
  end

  def get_insert_rate_query(caption_id, channel_code, city_code, day_part, rate)
    return "insert ignore into AMAGI_REPORTS_DB.ATS_CAPTION_RATES (caption_id, channel_code, city_code, day_part, rate) " +
      "values ('#{caption_id}', '#{channel_code}', '#{city_code}', '#{day_part}', '#{rate}') " +
      "on duplicate key update channel_code = '#{channel_code}', city_code = '#{city_code}', " +
      "day_part = '#{day_part}', rate = '#{rate}'"
  end
 
  def get_delete_campaign_query(campaign_id)
    return "delete from AMAGI_REPORTS_DB.ATS_CAMPAIGNS where campaign_id = '#{campaign_id}'"
  end

  def get_delete_caption_query(caption_id)
    return "delete from AMAGI_REPORTS_DB.ATS_CAPTIONS where caption_id = '#{caption_id}'"
  end

  def get_delete_rate_query(caption_id)
    return "delete from AMAGI_REPORTS_DB.ATS_CAPTION_RATES where caption_id = '#{caption_id}'"
  end
end
