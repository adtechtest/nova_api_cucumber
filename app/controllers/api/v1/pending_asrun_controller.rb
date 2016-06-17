class Api::V1::PendingAsrunController < ApplicationController
  before_filter :authenticate

  api :GET, "/v1/pending_asrun.json", "Returns list of scheduled spots for which asrun data is not available."
  param :deal_id, String, :desc => "deal-id paramter.", :required => true
  param :campaign_id, String, :desc => "campaign-id parameter."
  param :caption_id, String, :desc => "caption-id parameter."
  param :channel, String, :desc => "channel-code parameter.", :required => true
  param :start_date, /\d{4}-\d{2}-\d{2}/, :desc => "Start Date parameter in YYYY-mm-dd format", :required => true
  param :end_date, /\d{4}-\d{2}-\d{2}/, :desc => "End Date parameter in YYYY-mm-dd format", :required => true
  example <<-EOS
    INPUT:
    http://nova.amagi.com/api/v1/pending_asrun.json?deal_id=3U0M1TG9YYRP&campaign_id=&caption_id=&channel=ZT&start_date=2015-03-17&end_date=2015-03-17

    OUTPUT:
    {
    "status": 0,
    "data": [
        {
            "deal_id": "3U0M1TG9YYRP",
            "campaign_id": "1357SEYVCF15",
            "caption_id": "4LLO7CILNF2N",
            "channel_code": "ZT",
            "creative_id": "RTV105",
            "date": "2015-03-17",
            "spot_count": 2
        },
        {
            "deal_id": "3U0M1TG9YYRP",
            "campaign_id": "5RI0UBHG7L58",
            "caption_id": "7A0HPWY0MHCL",
            "channel_code": "ZT",
            "creative_id": "HLB220",
            "date": "2015-03-17",
            "spot_count": 2
        },
        {
            "deal_id": "3U0M1TG9YYRP",
            "campaign_id": "5RI0UBI14KGC",
            "caption_id": "7A0HPX05K1UH",
            "channel_code": "ZT",
            "creative_id": "HLB320",
            "date": "2015-03-17",
            "spot_count": 2
        }
      ]
    }
  EOS
  def pending_asrun_dsp
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
    
    query = File.read('sql/pending_asrun.sql')
    query.gsub! '{channel_code}', channel_code
    query.gsub! '{deal_id}', deal_id
    query.gsub! '{campaign_id}', campaign_id
    query.gsub! '{start_date}', start_date
    query.gsub! '{end_date}', end_date
    query.gsub! '{caption_id}', caption_id

    con = ActiveRecord::Base.connection
    print query
    @asrun_dsps = con.exec_query(query)
    print "Query executed...\n"
    Rails.logger.debug("Query executed...\n");
    result = {}
    result["status"] = 0
    result["data"] = []
    @asrun_dsps.each do |asrun_dsp|
      result["data"].push PendingAsrunDetail.to_map(asrun_dsp)
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

