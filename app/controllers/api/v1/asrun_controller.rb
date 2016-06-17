class Api::V1::AsrunController < ApplicationController
  before_filter :authenticate

  api :GET, "/v1/asrun.json", "Returns list of asrun-spot-details"
  param :deal_id, String, :desc => "deal-id paramter.", :required => true
  param :campaign_id, String, :desc => "campaign-id parameter."
  param :caption_id, String, :desc => "caption-id parameter."
  param :channel, String, :desc => "channel-code parameter.", :required => true
  param :start_date, /\d{4}-\d{2}-\d{2}/, :desc => "Start Date parameter in YYYY-mm-dd format", :required => true
  param :end_date, /\d{4}-\d{2}-\d{2}/, :desc => "End Date parameter in YYYY-mm-dd format", :required => true
  example <<-EOS
    INPUT:
  	http://nova.amagi.com/api/v1/asrun.json?deal_id=3U0M1TFQP9JG&campaign_id=&caption_id=3FL2IX8CZSDW&channel=IB&start_date=2016-01-01&end_date=2016-01-05


    OUTPUT:
    {
    "status": 0,
    "data": [
	        {
	            "deal_id": "3U0M1TFQP9JG",
	            "campaign_id": "3FL2IX6LUO21",
	            "caption_id": "3FL2IX8CZSDW",
	            "channel_code": "IB",
	            "city_code": "DL",
	            "creative_id": "BRH210IB",
	            "date": "2016-01-03",
	            "daypart": "Morning",
	            "spot_count": 7,
	            "aired_times": "07:54:37,10:55:16,09:56:19,07:24:37,09:40:09,10:27:03,08:22:03"
	        },
	        {
	            "deal_id": "3U0M1TFQP9JG",
	            "campaign_id": "3FL2IX6LUO21",
	            "caption_id": "3FL2IX8CZSDW",
	            "channel_code": "IB",
	            "city_code": "DL",
	            "creative_id": "BRH210IB",
	            "date": "2016-01-03",
	            "daypart": "Rest of Day",
	            "spot_count": 7,
	            "aired_times": "16:52:38,13:51:07,12:12:34,12:53:06,15:42:49,14:27:42,13:14:08"
	        },
	        {
	            "deal_id": "3U0M1TFQP9JG",
	            "campaign_id": "3FL2IX6LUO21",
	            "caption_id": "3FL2IX8CZSDW",
	            "channel_code": "IB",
	            "city_code": "DL",
	            "creative_id": "BRH210IB",
	            "date": "2016-01-03",
	            "daypart": "Evening",
	            "spot_count": 6,
	            "aired_times": "21:44:09,20:54:16,18:25:32,22:38:47,18:54:06,18:16:27"
	        }
    	]
	}
  EOS
  def asrun_dsp
    headers['Access-Control-Allow-Origin'] = '*'
    start_date = params[:start_date]
    if start_date.nil? or (start_date =~ /^\d{4}-\d{2}-\d{2}$/).nil?
      @status = 1
      @error = "start_date '#{start_date}' is invalid"
      return
    end
  
    date_format = I18n.t "date.formats.js"
    begin 
      start_date_d = DateTime.strptime(start_date, date_format)
    rescue
      @status = 1
      @error = "start_date should be in #{date_format} format"
    end

    end_date = params[:end_date]
    if end_date.nil? or (end_date =~ /^\d{4}-\d{2}-\d{2}$/).nil?
      @status = 1
      @error = "end_date '#{end_date}' is invalid"
      return
    end
  
     begin 
     end_date_d = DateTime.strptime(end_date, date_format)
    rescue
      @status = 1
      @error = "end_date should be in #{date_format} format"
    end
    

    deal_id = params[:deal_id]
    if deal_id.blank?
      deal_id = "%"
    end

    campaign_id = params[:campaign_id]
    if campaign_id.blank?
      campaign_id = "%"
    end

    caption_id = params[:caption_id]
    if caption_id.blank?
      caption_id = "%"
    end

    channel_code = params[:channel]
    if channel_code.blank?
      channel_code = "%"
    end
    
    query = File.read('sql/asrun.sql')
    query.sub! '{channel_code}', channel_code
    query.sub! '{deal_id}', deal_id
    query.sub! '{campaign_id}', campaign_id
    query.sub! '{start_date}', start_date
    query.sub! '{end_date}', end_date
    query.sub! '{caption_id}', caption_id

    con = ActiveRecord::Base.connection
    print query
    @asrun_dsps = con.exec_query(query)
    print "Query executed...\n"
    Rails.logger.debug("Query executed...\n");
    result = {}
    result["status"] = 0
    result["data"] = []
    @asrun_dsps.each do |asrun_dsp|
      result["data"].push AsrunDetail.to_map(asrun_dsp)
    end

    render :json => result.to_json
  end

 
  def authenticate
    headers['Access-Control-Allow-Origin'] = '*'
    authenticate_or_request_with_http_basic('Administration') do |username, password|
      username == Rails.configuration.api.username && password == Rails.configuration.api.password
    end
  end
end

