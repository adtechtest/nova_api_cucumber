class Api::V1::AtsController < ApplicationController
  #before_filter :authenticate

  skip_before_filter  :verify_authenticity_token

  api :POST, "/api/v1/ats/import_plan", "Post DSP plan info to ATS"
  example <<-EOS
    INPUT
      http://nova.amagi.com/api/v1/ats/import_plan
      {
        "id": 19,
        "start_date": "2016-01-01",
        "end_date": "2016-01-01",
        "name": "campaign name1",
        "client": {
          "id": 11,
          "name": "NRI Hospital 2"
        }
        "geocampaigns": [
          {
            "id": 1121,
            "name": "NRI Hospital Delhi",
            "geography_code": "DL",
            "product_category": "product1",
            "brand_name": "brand1",
            "captions": [
              {
                "id": 11232,
                "name": "NRI Hospital Delhi 10 sec",
                "duration": 12,
                "creative_name": "ABCD_111",
                "rotate_plan": [
                  {
                    "channel_code": "ZT",
                    "daypart": "Morning",
                    "date": "2016-05-01",
                    "spot_count": 3,
                    "rate": 110.0
                  },
                  {
                    "channel_code": "ZT",
                    "daypart": "Evening",
                    "date": "2016-05-02",
                    "spot_count": 2,
                    "rate": 140.0
                  }
                ]
              }
            ]
          }
        ]
      }
    OUTPUT:
      {
        "status": 0,
        "result": "Plan is imported successfully"
      }
      (or)
      {
        "status": 1,
        "result": "Invalid JSON content"
      }
  EOS
  def import_plan
    headers['Access-Control-Allow-Origin'] = '*'
    
    begin
      data = Oj.load(params[:json])
      token1 = params[:authenticity_token]
      token2 = Rails.configuration.authenticity_token
      if !token2.nil? and !token2.strip.empty?
        if token1.nil? or token1 != token2.strip
          raise "authenticity token is not correct"
        end
      end
  
      #file_path = "/home/rajesh/Downloads/test1/schedule.json"
      #file = File.new(file_path, "r+")
      #content = file.read()
      #data = Oj.load(content)
      
      jclient = data["client"]
      client_id = jclient["id"]
      client_name = jclient["name"]
      clients = AtsClient.where(DSP_CLIENT_ID: client_id)
      if clients.length == 0
        client = AtsClient.new
        client.NAME = client_name
        client.DSP_CLIENT_ID = client_id
        client.save
      else
        client = clients.first
        if client.NAME != client_name
          client.NAME = client_name
          client.save
        end
      end
      
      deal_id = data["id"]
      deal = AtsDeal.where(deal_id: deal_id)
      if deal
        deal.destroy_all
      end
      
      deal = AtsDeal.new
      deal.DEAL_ID = deal_id
      deal.AMAGI_CONTACT_NAME = "DSP"
      deal.FILE_NAME = "DSP_#{deal.DEAL_ID}"
      deal.client = client
      deal.CLIENT = client.NAME
      
      start_date = data["start_date"]
      end_date = data["end_date"]
      
      campaigns = []
      geo_campaigns = data["geocampaigns"]
      geo_campaigns.each do |geo_campaign|
        campaign_id = geo_campaign["id"]
        name = geo_campaign["name"]
        geography_code = geo_campaign["geography_code"]
        
        campaign_id = geo_campaign["id"]
        dcampaigns = AtsCampaign.where(CAMPAIGN_ID: campaign_id)
        if dcampaigns.length > 0 
          campaign = dcampaigns.first
          raise "campaign #{campaign_id} already exists (deal id: '#{campaign.DEAL_ID}')"
        end
        campaign = AtsCampaign.new
        campaign.CAMPAIGN_ID = geo_campaign["id"]
        campaign.CITY_CODE = geography_code
        campaign.NAME = geo_campaign["name"]
        campaign.PRODUCT_CATEGORY = geo_campaign["product_category"]
        campaign.BRAND_NAME = geo_campaign["brand_name"]
        campaign.PRODUCT_SUB_CATEGORY = geo_campaign["product_sub_category"]
        campaign.TELECAST_CITIES = geo_campaign["telecast_cities"]
      
        if geography_code.blank?
          raise "geography code is null for campaign id: '#{campaign.CAMPAIGN_ID}'"
        end
      
        begin
          campaign.VALID_FROM = Date.strptime(start_date, "%Y-%m-%d")
        rescue
          raise "invalid start date: #{start_date}, campaign_id: '#{campaign.CAMPAIGN_ID}'"
        end
        begin
          campaign.VALID_TILL = Date.strptime(end_date, "%Y-%m-%d")
        rescue
          raise "invalid end date: #{end_date}, campaign_id: '#{campaign.CAMPAIGN_ID}'"
        end
      
        captions = []
        jcaptions = geo_campaign["captions"]
        jcaptions.each do |jcaption|
          if jcaption["duration"].blank?
            raise "caption duration is blank for caption: '#{caption.CAPTION_ID}'"
          end
          caption_id = jcaption["id"]
          dcaptions = AtsCaption.where(CAPTION_ID: caption_id)
          if dcaptions.length > 0 
            caption = dcaptions.first
            raise "caption '#{caption_id}' already exists (campaign id: '#{caption.CAMPAIGN_ID}')"
          end
          caption = AtsCaption.new
          caption.CAPTION_ID = jcaption["id"]
          caption.CAPTION_NAME = jcaption["name"]
          caption.SPOT_DURATION = jcaption["duration"].to_i.to_s
          caption.AD_NAME = jcaption["creative_name"]
          caption.SCHEDULE_TYPE = "STRICT"
          caption.SHOW_IN_ADMON = 'Y'
          caption.ON_HOLD = "N"
       
          if caption.CAPTION_ID.blank?
            raise "caption id can't be blank, campaign id: '#{campaign.CAMPAIGN_ID}'"
          end
          if caption.SPOT_DURATION == 0
            raise "caption duration is not a valid number, caption id: '#{caption.CAPTION_ID}'"
          end
          if caption.AD_NAME.blank?
            raise "ad name can't be blank. caption id: '#{caption.CAPTION_ID}'"
          end
          if !caption.AD_NAME.match("^[a-zA-Z0-9_]+$")
            raise "'#{caption.AD_NAME}' should consist of alpha number characters and _ only (caption id: '#{caption.CAPTION_ID}')"
          end
          channel_to_daypart_to_rate_map = {}
          rotates = []
          ro_rotates = []
          jrotates = jcaption["rotate_plan"]
          jrotates.each do |jrotate|
            rotate = AtsRotatePlan.new
            rotate.CITY_CODE = campaign.CITY_CODE
            rotate.ROTATE_DATE = jrotate["date"]
            rotate.DAY_PART = jrotate["daypart"]
            rotate.ROTATES = jrotate["spot_count"]
            rotate.COST_PER_ROTATE = jrotate["rate"].to_f
            rotate.CHANNEL_CODE = jrotate["channel_code"]
            rotates.push rotate
      
            daypart_to_rate_map = channel_to_daypart_to_rate_map[rotate.CHANNEL_CODE]
            if daypart_to_rate_map.nil?
              daypart_to_rate_map = {}
              channel_to_daypart_to_rate_map[rotate.CHANNEL_CODE] = daypart_to_rate_map
            end
            daypart_to_rate_map[rotate.DAY_PART] = rotate.COST_PER_ROTATE
            
            ro_rotate = AtsRoRotatePlan.new
            ro_rotate.CITY_CODE = campaign.CITY_CODE
            ro_rotate.ROTATE_DATE = jrotate["date"]
            ro_rotate.DAY_PART = jrotate["daypart"]
            ro_rotate.ROTATES = jrotate["spot_count"]
            ro_rotate.COST_PER_ROTATE = jrotate["rate"]
            ro_rotate.CHANNEL_CODE = jrotate["channel_code"]
            ro_rotates.push ro_rotate
          end
       
          caption_channels = []
          caption_rates = []
          caption_internal_rates = []
          channel_to_daypart_to_rate_map.keys.each do |channel|
            daypart_to_rate_map = channel_to_daypart_to_rate_map[channel]
            daypart_to_rate_map.keys.each do |daypart|
              rate = daypart_to_rate_map[daypart]
              caption_rate = AtsCaptionRate.new
              caption_rate.CITY_CODE = campaign.CITY_CODE
              caption_rate.CHANNEL_CODE = channel
              caption_rate.DAY_PART = daypart
              caption_rate.RATE = rate
              caption_rate.UNIT = 10
              caption_rates.push caption_rate
      
              caption_internal_rate = AtsCaptionInternalRate.new
              caption_internal_rate.CITY_CODE = campaign.CITY_CODE
              caption_internal_rate.CHANNEL_CODE = channel
              caption_internal_rate.DAY_PART = daypart
              caption_internal_rate.UNIT = 10
              caption_internal_rate.RATE = rate
              caption_internal_rates.push caption_internal_rate
      
              caption_channel = AtsCaptionChannel.new
              caption_channel.CHANNEL_CODE = channel
              caption_channel.CITY_CODE = campaign.CITY_CODE
              caption_channel.DAY_PART = daypart
              caption_channels.push caption_channel
            end
          end
          caption.rotates = rotates
          caption.ro_rotates = ro_rotates
          caption.rates = caption_rates
          caption.internal_rates = caption_internal_rates
          caption.channels = caption_channels
      
          captions.push caption
        end
      
        campaign.captions = captions
        campaigns.push campaign
      end
      
      deal.campaigns = campaigns
      deal.save
      
      result = {}
      result[:status] = 0
      result[:result] = "success"
      render :json => result.to_json
    rescue Exception => e
      result = {}
      result[:status] = 1
      result[:result] = e.message
      puts e.backtrace
      render :json => result.to_json
    end
  end

  def authenticate
    headers['Access-Control-Allow-Origin'] = '*'
    authenticate_or_request_with_http_basic('Administration') do |username, password|
      username == Rails.configuration.scheduling.username && password == Rails.configuration.scheduling.password
    end
  end
end
