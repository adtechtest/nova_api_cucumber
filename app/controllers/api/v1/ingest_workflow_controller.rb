class Api::V1::IngestWorkflowController < ApplicationController
  before_filter :authenticate

  resource_description do
    resource_id 'ingest_workflow'
    short 'Ingest workflow related APIs.'
    api_base_url 'api/v1/ingest_workflow'
    description 'Ingest workflow related APIs'
  end

  api :GET, "/clients.json", "Returns list of clients. Search clients using a search term."
  param :search, String, :desc => "Searched against client's name."
  param :limit, :number, :desc => "No of results to return"
  param :offset, :number, :desc => "No of rows to skip"
  example <<-EOS
    INPUT:
      http://nova.amagi.com/api/v1/ingest_workflow/clients.json?search=Chit
      http://nova.amagi.com/api/v1/ingest_workflow/clients.json?limit=20

    OUTPUT:
      {
        "status": 0,
        "clients": [
          {
            "id": 14121,
            "name": "Siri Yoga Chit Funds Pvt Ltd"
          },
          {
            "id": 14412,
            "name": "Siriyoga Chit Funds Pvt Ltd"
          }
        ]
      }
  EOS
  def clients
    limit = params[:limit] || 10
    offset = params[:offset] || 0
    search = params[:search] || ""
    if !search.blank? and fishy?(search)
      render_error_msg "Search term looks fishy. Only alphanumeric characters are allowed." and return
    end

    q = "%#{search}%"
    clients = Client.where("NAME like ?", q).limit(limit).offset(offset)

    resp = build_response(clients, ["id", "name"])
    render :json => {"status" => 0, "clients" => resp}
  end


  api :GET, "/campaigns.json", "Search campaigns using either name or client_id."
  param :client_id, String, :desc => "Valid client_id."
  param :name, String, :desc => "Seach by campaign name."
  param :channel_code, String, :desc => "Filter using channel_code."
  param :limit, :number, :desc => "No of results to return"
  param :offset, :number, :desc => "No of rows to skip"
  example <<-EOS
    INPUT:
      http://nova.amagi.com/api/v1/ingest_workflow/campaigns.json?name=Chit
      http://nova.amagi.com/api/v1/ingest_workflow/campaigns.json?client_id=14121
      http://nova.amagi.com/api/v1/ingest_workflow/campaigns.json?client_id=13496&channel_code=UM

    OUTPUT:
      {
        "status": 0,
        "campaigns": [
          {
            "id": "73X8M3BB7DDO",
            "name": "Siri Yoga Chit Funds",
            "start_date": "2012-10-24",
            "end_date": "2012-10-24",
            "client_id": 14121,
            "client_name": "Siri Yoga Chit Funds Pvt Ltd"
          }
        ]
      }
  EOS
  def campaigns
    name = params[:name]
    client_id = params[:client_id]
    channel_code = params[:channel_code]

    last_thirth_day = Date.current - 30.days

    campaigns = AtsCampaign.joins("inner join ATS_DEALS ad on ad.DEAL_ID = ATS_CAMPAIGNS.DEAL_ID inner join ATS_CLIENTS ac on ac.ID = ad.CLIENT_ID")
                .select("ATS_CAMPAIGNS.CAMPAIGN_ID as ID, ATS_CAMPAIGNS.NAME, VALID_TILL as END_DATE, VALID_FROM as START_DATE, ac.ID as CLIENT_ID, ac.NAME as CLIENT_NAME").where("ATS_CAMPAIGNS.CITY_CODE = 'MA'")

    if !channel_code.blank? 
      campaigns = campaigns.joins("inner join ATS_CAPTIONS aa on aa.CAMPAIGN_ID = ATS_CAMPAIGNS.CAMPAIGN_ID inner join ATS_ROTATE_PLANS ap on ap.CAPTION_ID = aa.CAPTION_ID")
                  .where("ap.ROTATE_DATE > ? and ap.CHANNEL_CODE = ?", last_thirth_day, channel_code).distinct
    else
      campaigns = campaigns.joins("inner join ATS_CAPTIONS aa on aa.CAMPAIGN_ID = ATS_CAMPAIGNS.CAMPAIGN_ID inner join ATS_ROTATE_PLANS ap on ap.CAPTION_ID = aa.CAPTION_ID")
                  .where("ap.ROTATE_DATE > ?", last_thirth_day).distinct
    end

    if !name.blank?
      if fishy?(name)
        render_error_msg "Name looks fishy. Only alphanumeric characters are allowed." and return
      end
      q = "%#{name}%"
      campaigns = campaigns.where("ATS_CAMPAIGNS.NAME like ? and VALID_TILL > ?", q, last_thirth_day)
    elsif !client_id.blank?
      campaigns = campaigns.where("ac.ID = ? and VALID_TILL > ?", client_id, last_thirth_day)
    end

    interested_fields = ["id", "name", "start_date", "end_date", "client_id", "client_name"]
    resp = build_response(campaigns, interested_fields)
    render :json => {"status" => 0, "campaigns" => resp}
  end


  api :GET, "/captions.json", "Search captions by campaign_id."
  param :campaign_id, String, :desc => "Valid campaign_id."
  example <<-EOS
    INPUT:
      http://nova.amagi.com/api/v1/ingest_workflow/captions.json?campaign_id=1SJG9QRLZDMW

    OUTPUT:
      {
        "status": 0,
        "captions": [
          {
            "id": "73B98DASL5HF",
            "name": "TomJerry_Collectability",
            "ad_name": "TMJ820"
          }
        ]
      }
  EOS
  def captions
    campaign_id = params[:campaign_id]
    return unless is_valid_id?(campaign_id)
    captions = AtsCaption.where(CAMPAIGN_ID: campaign_id).select("CAPTION_ID as ID, CAPTION_NAME as NAME, AD_NAME")
    resp = build_response(captions, ["id", "name", "ad_name"])
    render :json => {"status" => 0, "captions" => resp}
  end

  api :GET, "/channels.json", "Returns list of channels"
  param :limit, :number, :desc => "No of results to return"
  param :offset, :number, :desc => "No of rows to skip"
  param :caption_id, String, :desc => "Valid caption-ID"
  example <<-EOS
    INPUT:
      http://nova.amagi.com/api/v1/ingest_workflow/channels.json?limit=10&offset=1
      http://nova.amagi.com/api/v1/ingest_workflow/channels.json?caption_id=135CKESJ3U6W&limit=10&offset=2

    OUTPUT:
      {
        "status": 0,
        "channels": [
          {
            "code": "ZN",
            "name": "Zee News"
          },
          {
            "code": "ZT",
            "name": "Zee TV"
          }
        ]
      }

      {
        "status": 1,
        "error": "unable to connect to database"
      }

  EOS
  def channels
    limit = params[:limit] || 10
    offset = params[:offset] || 0
    caption_id = params[:caption_id]

    return unless is_valid_id?(caption_id)

    channels = Channel.all.limit(limit).offset(offset)
    if !caption_id.blank?
      channel_codes = AtsRotatePlan.where(CAPTION_ID: caption_id).select("CHANNEL_CODE")
      if channel_codes.empty?
        render_invalid_caption_id and return
      end
      channels = Channel.where(CODE: channel_codes)
    end

    resp = build_response(channels, ["code", "name"])
    render :json => {"status" => 0, "channels" => resp}
  end

  api :GET, "/cities.json", "Returns list of cities. Search cities using caption_id."
  param :caption_id, String, :desc => "Valid caption-ID"
  example <<-EOS
    INPUT:
      http://nova.amagi.com/api/v1/ingest_workflow/cities.json?caption_id=135CKESJ3U6W

    OUTPUT:
      {
        "status": 0,
        "cities": [
          {
            "code": "BA",
            "name": "Bangalore"
          },
          {
            "code": "MU",
            "name": "Mumbai"
          }
        ]
      }
  EOS
  def cities
    caption_id = params[:caption_id]
    return unless is_valid_id?(caption_id)

    city_codes = AtsRotatePlan.where(CAPTION_ID: caption_id).select("CITY_CODE")
    if city_codes.empty?
      render_invalid_caption_id and return
    end

    cities = City.where(CODE: city_codes)
    resp = build_response(cities, ["code", "name"])
    render :json => {"status" => 0, "cities" => resp}
  end



  api :GET, "/salespersons.json", "Search sales personnel by name."
  param :name, String, :desc => "Search term."
  param :limit, :number, :desc => "No of results to return"
  param :offset, :number, :desc => "No of rows to skip"
  example <<-EOS
    INPUT:
      http://nova.amagi.com/api/v1/ingest_workflow/salespersons.json?name=Alok

    OUTPUT:
      {
        "status": 0,
        "salespersons": [
          {
            "id": 345,
            "name": "Anshuman Basak",
            "email": "anshuman.basak@amagi.com"
          }
        ]
      }
  EOS
  def salespersons
    limit = params[:limit] || 10
    offset = params[:offset] || 0
    name = params[:name]
    if !name.blank? and fishy?(name)
      render_error_msg "Only alphanumeric characters are allowed in name." and return
    end

    q = "%#{name}%"
    salespersons = Salesperson.where("NAME like ?", q).select("ID, NAME, MAIL_ID as EMAIL").limit(limit).offset(offset)

    resp = build_response(salespersons, ["id", "name", "email"])
    render :json => {"status" => 0, "salespersons" => resp}
  end

  private

  def is_valid_id? id
    if id.blank?
      render_error_msg "Id can't be blank." and return false
    end
    if fishy?(id)
      render_error_msg "Id looks fishy. Only alphanumeric is permitted." and return false
    end
    return true
  end

  def render_invalid_caption_id
      render_error_msg "No record found for this caption_id."
  end

  def render_error_msg msg
      render :json => {"status" => 1, "error" => msg}
  end

  def build_response items, keys, map={}
    resp = items.map do |item|
      res = {}
      keys.each do |key|
        res[key] = item.send(key.upcase)
      end unless item.nil?
      res
    end
    return resp.compact
  end

  def fishy? term
    term.match(/^[a-zA-Z0-9\ ]+$/).nil?
  end

  def authenticate
    headers['Access-Control-Allow-Origin'] = '*'
    authenticate_or_request_with_http_basic('Administration') do |username, password|
      username == Rails.configuration.api.username && password == Rails.configuration.api.password
    end
  end
end
