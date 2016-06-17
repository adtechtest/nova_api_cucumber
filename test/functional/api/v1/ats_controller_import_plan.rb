require 'test_helper'

class Api::V1::AtsControllerTest < ActionController::TestCase
  test "import plan" do
    data = File.read('data/dsp_plan1.json')
    jdata = JSON.parse(data)
    deal_id = jdata["id"]

    AtsDeal.find(deal_id).destroy

    post(:import_plan, {'json' => data})
    assert_response :success
    body = JSON.parse(response.body)
    assert_equal 0, body["status"]
    deal = AtsDeal.find(deal_id)

    client_id = jdata["client"]["id"]
    client = AtsClient.where(DSP_CLIENT_ID: client_id).first
    assert_equal client.NAME, jdata["client"]["name"]
    
    campaign = deal.campaigns.first
    caption = campaign.captions.first
    rate = caption.rates[0]
    irate = caption.internal_rates[0]
    rotate = caption.rotates[0]
    ro_rotate = caption.rotates[0]

    assert_equal deal.campaigns.length, jdata["geocampaigns"].length

    jcampaign = jdata["geocampaigns"][0]
    jcaption = jcampaign["captions"][0]
    jrotate = jcaption["rotate_plan"][0]

    assert_equal campaign.captions.length, jcampaign["captions"].length

    assert_equal deal.client.DSP_CLIENT_ID, jdata["client"]["id"].to_s
    assert_equal deal.client.NAME, jdata["client"]["name"]
    assert_equal campaign.CAMPAIGN_ID, jcampaign["id"].to_s
    assert_equal campaign.NAME, jcampaign["name"].to_s
    assert_equal campaign.BRAND_NAME, jcampaign["brand_name"]
    assert_equal campaign.PRODUCT_CATEGORY, jcampaign["product_category"]
    assert_equal campaign.PRODUCT_SUB_CATEGORY, jcampaign["product_sub_category"]

    assert_equal caption.CAPTION_NAME, jcaption["name"]
    assert_equal caption.SPOT_DURATION, jcaption["duration"]
    assert_equal caption.AD_NAME, jcaption["creative_name"]
    assert_equal caption.SCHEDULE_TYPE, "STRICT"

    assert_equal rate.CAPTION_ID, irate.CAPTION_ID
    assert_equal rate.CHANNEL_CODE, irate.CHANNEL_CODE
    assert_equal rate.CITY_CODE, irate.CITY_CODE
    assert_equal rate.DAY_PART, irate.DAY_PART 

    assert_equal rotate.ROTATES, jrotate["spot_count"]
    assert_equal rotate.ROTATE_DATE, Date.parse(jrotate["date"])

    assert_equal caption.rotates.length, jcaption["rotate_plan"].length
    assert_equal caption.ro_rotates.length, jcaption["rotate_plan"].length
  end
end
