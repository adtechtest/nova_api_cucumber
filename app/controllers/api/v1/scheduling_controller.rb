class Api::V1::SchedulingController < ApplicationController
  #before_filter :authenticate

  skip_before_filter  :verify_authenticity_token
  api :GET, "/api/v1/channels.json", "Returns list of channels"
  param :date, /\d{4}-\d{2}-\d{2}/, :desc => "Date parameter"
  example <<-EOS
    INPUT:
      http://nova.amagi.com/api/v1/channels.json
    OUTPUT:
      {
        "status": 0,
        "channels": [
          {
            "code": "AT",
            "name": "Aajtak"
          },
          {
            "code": "CA",
            "name": "CNBC Awaaz"
          },
          {
            "code": "CT",
            "name": "Colors Test"
          }
        ]
      }
  EOS
  def channels
    headers['Access-Control-Allow-Origin'] = '*'
    date = params[:date] || Date.today
    channels = Channel.where("valid_to is null or valid_to >= ?", date).order(:NAME)

    result = {}
    result["status"] = 0
    result["channels"] = []
    channels.each do |channel|
      map = {}
      map["code"] = channel.CODE
      map["name"] = channel.NAME
      result["channels"].push map
    end

    render :json => result.to_json
  end

  api :GET, "/api/v1/channels/:channel_code/cities.json", "Returns list of cities"
  param :date, /\d{4}-\d{2}-\d{2}/, :desc => "Date parameter", :required => true
  example <<-EOS
    INPUT:
      http://nova.amagi.com/api/v1/channels/ZN/cities.json?date=2015-01-01
    OUTPUT:
      {
        "status": 0,
        "cities": [
          {
            "code": "IH",
            "name": "Bihar"
          },
          {
            "code": "JK",
            "name": "JammuKashmir"
          },
          {
            "code": "JH",
            "name": "Jharkhand"
          },
          {
            "code": "MA",
            "name": "Master"
          }
        ]
      }
  EOS
  def cities
    headers['Access-Control-Allow-Origin'] = '*'
    cities = City.order(:NAME)
    channel_code = params[:channel_code]
    date = params[:date]

    cities = City.where("valid_to is null or valid_to >= ?", date).order(:NAME)

    result = {}
    result["status"] = 0
    result["cities"] = []
    cities.each do |city|
      map = {}
      map["code"] = city.CODE
      map["name"] = city.NAME
      result["cities"].push map
    end

    render :json => result.to_json
  end

  api :GET, "/api/v1/channels/:channel_code/dayparts.json", "Returns list of dayparts"
  param :date, /\d{4}-\d{2}-\d{2}/, :desc => "Date parameter", :required => true
  example <<-EOS
    INPUT:
      http://nova.amagi.com/api/v1/channels/ZN/dayparts.json
    OUTPUT:
      {
        "status": 0,
        "dayparts": [
          {
            "channel_code": "ZN",
            "code": "Evening",
            "name": "Evening",
            "start_time": "18:00:00",
            "end_time": "23:59:59"
          },
          {
            "channel_code": "ZN",
            "code": "Morning",
            "name": "Morning",
            "start_time": "06:00:00",
            "end_time": "11:59:59"
          },
          {
            "channel_code": "ZN",
            "code": "Rest of Day",
            "name": "Rest of Day",
            "start_time": "12:00:00",
            "end_time": "17:59:59"
          }
        ]
      }
  EOS
  def dayparts
    headers['Access-Control-Allow-Origin'] = '*'
    channel_code = params[:channel_code]
    date = params[:date]

    dayparts = Daypart
               .where("channel_code = ? and valid_till is null and win_dow = dayofweek(?)", channel_code, date)
               .select([:CHANNEL_CODE, :WIN_LABEL, :WIN_BEGIN, :WIN_END])
               .order(:WIN_BEGIN)
  
    result = {}
    result["status"] = 0
    result["dayparts"] = []
    dayparts.each do |daypart|
      map = {}
      map["channel_code"] = daypart.CHANNEL_CODE
      map["code"] = daypart.WIN_LABEL
      map["name"] = daypart.WIN_LABEL
      map["start_time"] = daypart.WIN_BEGIN.strftime("%H:%M:%S")
      map["end_time"] = daypart.WIN_END.strftime("%H:%M:%S")
      result["dayparts"].push map
    end

    render :json => result.to_json
  end

  api :GET, "/api/v1/channels/:channel_code/local_captions.json", "Returns list of captions"
  param :date, /\d{4}-\d{2}-\d{2}/, :desc => "Date parameter", :required => true
  example <<-EOS
    INPUT:
      http://nova.amagi.com/api/v1/channels/ZN/local_captions.json?date=2015-01-01
    OUTPUT:
      {
        "status": 0,
        "captions": [
          {
            "id": "4UXBJJEFXO4T",
            "name": "Jainson Locks",
            "ad_name": "RTN210",
            "duration": 10,
            "campaign_id": "0JNKPP3H239W",
            "schedule_type": "EFFICIENT",
            "client_name": "Ratan and Company",
            "brand_name": "Jainson Locks",
            "rates": {
              "Evening": 0,
              "Morning": 0,
              "Rest of Day": 0
            },
            "city": "MQ",
            "cities": [
              "MQ"
            ]
          },
          {
            "id": "75KAJFEI4548",
            "name": "Disney Fairies n Mickey M",
            "ad_name": "DFN220",
            "duration": 20,
            "campaign_id": "100GX3XQ2PQA",
            "schedule_type": "STRICT",
            "client_name": "FERRERO INDIA PVT. LTD.",
            "brand_name": "Kinder Joy",
            "rates": {
              "Evening": 0,
              "Morning": 0,
              "Rest of Day": 0
            },
            "city": "MU",
            "cities": [
              "MU"
            ]
          }
        ]
      }
  EOS
  def local_captions
    headers['Access-Control-Allow-Origin'] = '*'
    date = params[:date]
    channel_code = params[:channel_code]

    con = ActiveRecord::Base.connection

    filename = 'sql/local_captions.sql'
    query = File.read(filename)
    query.gsub! '{date}', date
    query.gsub! '{channel_code}', channel_code
    local_captions = con.exec_query(query)

    id_to_caption_map = {}
    local_captions.each do |caption|
      caption_id = caption["caption_id"]
      map = id_to_caption_map[caption_id] || {}
      rate_map = map["rates"] || {}
      cities = map["cities"] || []

      caption_name = caption["caption_name"]
      ad_name = caption["ad_name"]
      duration = caption["duration"] || 0
      campaign_id = caption["campaign_id"]
      day_part = caption["day_part"]
      rate = caption["rate"]
      city_code = caption["city_code"]
      schedule_type = caption["schedule_type"]
      client_name = caption["client_name"] || ""
      brand_name = caption["brand_name"] || ""

      map["id"] = caption_id
      map["name"] = caption_name
      map["ad_name"] = ad_name
      map["duration"] = duration
      map["campaign_id"] = campaign_id
      map["schedule_type"] = schedule_type
      map["client_name"] = client_name
      map["brand_name"] = brand_name
      rate_map[day_part] = rate.to_f 
      
      map["rates"] = rate_map
      map["city"] = city_code
      id_to_caption_map[caption_id] = map
    end

    caption_id_to_city_array = get_master_caption_id_to_city_array_map(date, channel_code)

    result = {}
    result["status"] = 0
    result["captions"] = []
    id_to_caption_map.each do |id, caption|
      city_array = caption_id_to_city_array[id] || []
      city_array.push caption["city"]
      caption["cities"] = city_array
      result["captions"].push caption
    end

    render :json => result.to_json
  end

  api :GET, "/api/v1/channels/:channel_code/filler_captions.json", "Returns list of filler captions"
  example <<-EOS
    INPUT:
      http://nova.amagi.com/api/v1/channels/ZN/filler_captions.json?date=2015-01-01
    OUTPUT:
      {
        "status": 0,
        "filler_captions": [
          {
            "channel_code": "ZM",
            "city_code": "ALL",
            "ad_name": "FPR105",
            "duration": 5
          },
          {
            "channel_code": "ZM",
            "city_code": "ALL",
            "ad_name": "TVC230",
            "duration": 30
          },
          {
            "channel_code": "ZM",
            "city_code": "ALL",
            "ad_name": "AMG215",
            "duration": 15
          }
        ]
      }
  EOS
  def filler_captions
    headers['Access-Control-Allow-Origin'] = '*'
    channel_id = params[:channel_code]

    filler_captions = FillerCaption.where("CHANNEL_ID = ?", channel_id)
    result = {}
    result["status"] = 0
    result["filler_captions"] = []
    filler_captions.each do |caption|
      map = {}
      map["channel_code"] = caption.CHANNEL_ID
      map["city_code"] = caption.CITY_ID
      map["ad_name"] = caption.AD_NAME
      map["duration"] = caption.DURATION || 0
      result["filler_captions"].push map
    end

    render :json => result.to_json
  end

  api :GET, "/api/v1/channels/:channel_code/available_masters.json", "Returns list of available master spots"
  param :date, /\d{4}-\d{2}-\d{2}/, :desc => "Date parameter", :required => true
  example <<-EOS
    INPUT:
      http://nova.amagi.com/api/v1/channels/ZN/available_masters.json?date=2015-01-01
    OUTPUT:
      {
        "status": 0,
        "masters": [
          {
            "signature": "EBFZN_04_015",
            "day_part": "Morning",
            "playout_time": "09:23:40"
          },
          {
            "signature": "EBFZN_04_015",
            "day_part": "Evening",
            "playout_time": "18:20:35"
          },
          {
            "signature": "EBFZN_04_015",
            "day_part": "Rest of Day",
            "playout_time": "14:23:05"
          }
        ]
      }
  EOS
  def available_masters
    headers['Access-Control-Allow-Origin'] = '*'
    channel_code = params[:channel_code]
    date = params[:date]

    sig_to_dp_count_map = {}
    ro_spot_details = RoSpotDetail.where("SCH_DATE = ?", date).includes(:RoCampaignDetail).select { |e| e.RoCampaignDetail and e.RoCampaignDetail.CHANNEL_CODE == channel_code }
    ro_spot_details.each do |ro_spot_detail|
      campaign = ro_spot_detail.RoCampaignDetail
      signature = ro_spot_detail.SIGNATURE
      daypart = ro_spot_detail.DAY_PART_NAME
      spot_count = campaign.RO_TYPE == "CANCELLATION" ? -ro_spot_detail.SPOT_COUNT : ro_spot_detail.SPOT_COUNT

      if sig_to_dp_count_map[signature].blank?
        sig_to_dp_count_map[signature] = {}
      end
      dp_to_count_map = sig_to_dp_count_map[signature]
      if dp_to_count_map.blank?
        dp_to_count_map = {}
        sig_to_dp_count_map[signature] = dp_to_count_map
      end
      dp_to_count_map[daypart] = dp_to_count_map[daypart] ? dp_to_count_map[daypart] : 0
      dp_to_count_map[daypart] += spot_count
    end

    dp_to_sig_to_times_map = get_daypart_to_signature_to_times_map(date, channel_code)

    result = {}
    result["status"] = 0
    result["masters"] = []
    sig_to_dp_count_map.keys.each do |signature|
      dp_count_map = sig_to_dp_count_map[signature]
      dp_count_map.each do |dp, count|
        sig_to_times_map = dp_to_sig_to_times_map[dp] || {}
        times = sig_to_times_map[signature]
        for i in 0..count-1
          map = {}
          map["signature"] = signature
          map["day_part"] = dp == 'Day' ? 'Rest of Day' : dp
          map["playout_time"] = times.nil? ? "" : times[i]
          result["masters"].push map
        end
      end
    end

    render :json => result.to_json
  end

  api :GET, "/api/v1/channels/:channel_code/signature_captions.json", "Returns signature to caption mapping"
  param :date, /\d{4}-\d{2}-\d{2}/, :desc => "Date parameter", :required => true
  example <<-EOS
    INPUT:
      http://nova.amagi.com/api/v1/channels/ZN/signature_captions.json?date=2015-01-01
    OUTPUT:
      {
        "status": 0,
        "masters": [
          {
            "signature": "EBFZN_01_010",
            "captions": [
              "1MK39I8HY2HH"
            ],
            "duration": 10
          },
          {
            "signature": "DUBZN_26_020",
            "captions": [
              "8429YNC24XEN",
              "2HGJKISUR867"
            ],
            "duration": 20
          }
        ]
      }
  EOS
  def signature_captions
    headers['Access-Control-Allow-Origin'] = '*'
    channel_code = params[:channel_code]
    date = params[:date]

    file_name = RoSpotDetail.where("SCH_DATE = ?", date).joins("inner join RO_CAMPAIGN_DETAILS on RO_SPOT_DETAILS.RO_CAMPAIGN_DETAILS_ID = RO_CAMPAIGN_DETAILS.ID").where("CHANNEL_CODE = ?", channel_code).maximum("RO_CAMPAIGN_DETAILS.FILE_NAME")
    ro_signature_captions = RoSignatureCaption.where("FILE_NAME = ?", file_name).order("SLOT_NUMBER")
    signature_to_captions_map = {}
    ro_signature_captions.each do |ro_signature_caption|
      signature = ro_signature_caption.SIGNATURE
      caption_id = ro_signature_caption.CAPTION_ID
      captions = signature_to_captions_map[signature]
      if captions.nil?
        captions = []
        signature_to_captions_map[signature] = captions
      end
      captions.push caption_id
    end

    sig_to_duration_map = {}
    ro_spot_details = RoSpotDetail.where("SCH_DATE = ?", date).includes(:RoCampaignDetail).select { |e| e.RoCampaignDetail and e.RoCampaignDetail.CHANNEL_CODE == channel_code }
    ro_spot_details.each do |ro_spot_detail|
      signature = ro_spot_detail.SIGNATURE
      duration = ro_spot_detail.SPOT_DURATION
      sig_to_duration_map[signature] = duration
    end

    result = {}
    result["status"] = 0
    result["masters"] = []
    sig_to_duration_map.keys.each do |signature|
      captions = signature_to_captions_map[signature]
      map = {}
      map["signature"] = signature
      map["captions"] = captions
      map["duration"] = sig_to_duration_map[signature]
      result["masters"].push map
    end

    render :json => result.to_json
  end
 
  api :GET, "/api/v1/channels/:channel_code/planned_locals.json", "Returns plan and makegood details"
  param :date, /\d{4}-\d{2}-\d{2}/, :desc => "Date parameter", :required => true
  example <<-EOS
    INPUT:
      http://nova.amagi.com/api/v1/channels/ZN/planned_locals.json?date=2015-01-01
    OUTPUT:
    {
      "status": 0,
      "spots": [
        {
          "caption_id": "40KKVVGN7FUE",
          "channel_code": "ZN",
          "day_part": "Evening",
          "total_rotates": 81,
          "planned_sofar": 81,
          "played_rotates": 83,
          "asrun_pending": 0,
          "makegoods": -2,
          "rotates": 0,
          "schedule_type": "EFFICIENT",
          "end_date": "2015-05-31"
        },
        {
          "caption_id": "40KKVVGN7FUE",
          "channel_code": "ZN",
          "day_part": "Morning",
          "total_rotates": 91,
          "planned_sofar": 91,
          "played_rotates": 97,
          "asrun_pending": 0,
          "makegoods": -6,
          "rotates": 0,
          "schedule_type": "EFFICIENT",
          "end_date": "2015-05-31"
        }
      ]
    }
  EOS
  def planned_locals
    headers['Access-Control-Allow-Origin'] = '*'

    date = params[:date]
    channel_code = params[:channel_code]
 
    result = get_planned_locals(date, channel_code)

    render :json => result.to_json
  end

  def get_planned_locals(date, channel_code)
    caption_id_to_overscheduled_map = get_caption_id_to_dp_to_rotate_map('sql/future_overscheduled.sql', date, channel_code)
    caption_id_to_scheduled_map = get_caption_id_to_dp_to_rotate_map('sql/future_scheduled.sql', date, channel_code)
    caption_id_to_schedule_type_start_end_date_map = get_caption_id_to_schedule_type_start_end_date_map(date)
    caption_id_to_total_map = get_caption_id_to_dp_to_rotate_map('sql/total_planned.sql', date, channel_code)
    caption_id_to_planned_map = get_caption_id_to_dp_to_rotate_map('sql/planned_sofar.sql', date, channel_code)
    caption_id_to_current_map = get_caption_id_to_dp_to_rotate_map('sql/planned_current.sql', date, channel_code)
    caption_id_to_played_map = get_caption_id_to_dp_to_rotate_map('sql/played.sql', date, channel_code)
    caption_id_to_asrun_pending_map = get_caption_id_to_dp_to_rotate_map('sql/asrun_pending.sql', date, channel_code)

    result = {}
    result["status"] = 0
    result["planned_locals"] = []
    caption_id_to_total_map.each do |caption_id, daypart_to_total_map|
      daypart_to_asrun_pending_map = caption_id_to_asrun_pending_map[caption_id] || {}
      daypart_to_played_map = caption_id_to_played_map[caption_id] || {}
      daypart_to_planned_map = caption_id_to_planned_map[caption_id] || {}
      daypart_to_current_map = caption_id_to_current_map[caption_id] || {}
      daypart_to_overscheduled_map = caption_id_to_overscheduled_map[caption_id] || {}
      daypart_to_scheduled_map = caption_id_to_scheduled_map[caption_id] || {}
      schedule_type = caption_id_to_schedule_type_start_end_date_map[caption_id]['schedule_type']
      start_date = caption_id_to_schedule_type_start_end_date_map[caption_id]['start_date']
      end_date = caption_id_to_schedule_type_start_end_date_map[caption_id]['end_date']
      daypart_to_total_map.each do |daypart, total_count|
        asrun_pending_count = daypart_to_asrun_pending_map[daypart] || 0
        played_count = daypart_to_played_map[daypart] || 0
        planned_count = daypart_to_planned_map[daypart] || 0
        current_count = daypart_to_current_map[daypart] || 0
        overscheduled_count = daypart_to_overscheduled_map[daypart] || 0
        scheduled_count = daypart_to_scheduled_map[daypart] || 0
        if schedule_type == "STRICT" or schedule_type == "EFFICIENT"
          normal_count = current_count
          makegood_count = planned_count - played_count - asrun_pending_count - overscheduled_count
        elsif schedule_type == "OPEN_RO" or schedule_type == "OPEN_RO_ANY_DAY_PART"
          if start_date.to_s > date
            next
          elsif end_date.to_s >= date
            normal_count = total_count - played_count - asrun_pending_count - scheduled_count
            makegood_count = 0
          else
            normal_count = 0
            makegood_count = total_count - played_count - asrun_pending_count - scheduled_count
          end
          overscheduled_count = 0
        else
          raise "invalid schedule type '#{schedule_type}' for caption id: #{caption_id}"
        end

        map = {}
        map["caption_id"] = caption_id
        map["channel_code"] = channel_code
        map["daypart"] = daypart
        map["total_rotates"] = total_count
        map["planned_sofar"] = planned_count
        map["played_rotates"] = played_count
        map["asrun_pending"] = asrun_pending_count
        map["future_overscheduled"] = overscheduled_count
        map["future_scheduled"] = scheduled_count
        map["makegoods"] = makegood_count || 0
        map["rotates"] = normal_count || 0
        map["schedule_type"] = schedule_type
        map["start_date"] = start_date.to_s
        map["end_date"] = end_date.to_s
        if map["rotates"] != 0 or map["makegood"] != 0
          result["planned_locals"].push map
        end
      end
    end

    return result
  end

  api :POST, "/api/v1/channels/:channel_code/import_schedule", "Post schedule info"
  param :date, /\d{4}-\d{2}-\d{2}/, :desc => "Date parameter", :required => true
  param :channel_code, String, :desc => "Date parameter", :required => true
  example <<-EOS
    INPUT
      http://nova.amagi.com/api/v1/channels/ZN/import_schedule?date=2015-01-01
      {
         "Evening" : [
            {
               "signature" : "MODZT_10_035",
               "duration" : 35,
               "cities" : [
                  {
                     "captions" : [
                        {
                           "ad_name" : "FML320",
                           "name" : "Family Edit 1",
                           "duration" : 20,
                           "city" : "BA",
                           "id" : "7Q430S3841J3"
                        }
                     ],
                     "code" : "BA"
                  },
                  {
                     "captions" : [
                        {
                           "ad_name" : "RBN130",
                           "name" : "Rin Banker 30 Nl",
                           "duration" : 30,
                           "city" : "IH",
                           "id" : "1LKOS7M1GIMX"
                        }
                     ],
                     "code" : "IH"
                  }
               ]
            }
         ],
         "Morning" : [
            {
               "signature" : "MODZT_10_035",
               "duration" : 35,
               "cities" : [
                  {
                     "captions" : [
                        {
                           "ad_name" : "FML320",
                           "name" : "Family Edit 1",
                           "duration" : 20,
                           "city" : "BA",
                           "id" : "7Q430S3841J3"
                        }
                     ],
                     "code" : "BA"
                  }
               ]
            }
         ]
      }
    OUTPUT:
      {
        "status": 0,
        "result": "Schedule is imported successfully"
      }
      (or)
      {
        "status": 1,
        "result": "Invalid JSON content"
      }
  EOS
  def import_schedule
    headers['Access-Control-Allow-Origin'] = '*'
    
    begin
      date = params[:date]
      channel_code = params[:channel_code]
      data = Oj.load(params[:json])
      token1 = params[:authenticity_token]
      token2 = Rails.configuration.authenticity_token
      if !token2.nil? and !token2.strip.empty?
        if token1.nil? or token1 != token2.strip
          raise "authenticity token is not correct"
        end
      end
  
      #data = Oj.load(request.body.read)
      daypart_to_start_time_map = {}
      daypart_to_end_time_map = {}
      day = DateTime.parse(date)
      weekday = day.wday
      dayparts = Daypart.where(CHANNEL_CODE: channel_code, WIN_DOW: weekday+1).where("VALID_TILL IS NULL")
      dayparts.each do |daypart|
        name = daypart["WIN_LABEL"]
        start_time = daypart["WIN_BEGIN"]
        end_time = daypart["WIN_END"]
        daypart_to_start_time_map[name] = start_time.strftime("%H:%M:%S")
        daypart_to_end_time_map[name] = end_time.strftime("%H:%M:%S")
      end
      
      city_code_map = {}
      data.each { |daypart, maps|
        masters = maps['masters']
        if masters.nil?
          raise "masters field is missing in #{daypart} daypart"
        end
        masters.each { |signature, master|
          rotates = master['rotates']
          if rotates.nil?
            raise "rotates field is missing in #{daypart} daypart, #{signature}"
          end
          rotates.each do |rotate|
            cities = rotate['cities']
            if cities.nil?
              raise "cities field is missing in #{daypart} daypart, #{signature}"
            end
            cities.each { |city_code, city|
              captions = city['captions']
              captions.each do |caption|
                city_code_map[city_code] = true
              end
            }
          end
        }
      }
      city_codes = city_code_map.keys

      SchMatrixLocalAd.joins("inner join SCH_MATRIX_BREAKS b on SCH_MATRIX_LOCAL_ADS.SCH_MATRIX_BRK_ID = b.ID").where("b.SCH_DATE" => date, "b.CHANNEL_CODE" => channel_code, "SCH_MATRIX_LOCAL_ADS.CITY_CODE" => city_codes).delete_all
      Schedule.where(SCH_DATE: date, CHANNEL_CODE: channel_code, CITY_CODE: city_codes).delete_all

      data.each { |daypart, maps|
        Rails.logger.info "Daypart: #{daypart}"
        sig_to_count_map = {}
        masters = maps["masters"]
        masters.each { |signature, master|
          rotates = master["rotates"]
          rotates.each do |rotate|
            sig_count = sig_to_count_map[signature].blank? ? 1 : sig_to_count_map[signature]+1
            sig_to_count_map[signature] = sig_count
            win_begin = daypart_to_start_time_map[daypart]
            win_end = daypart_to_end_time_map[daypart]
            if win_begin.blank? or win_end.blank?
              raise "'#{daypart}' daypart is not found in WINDOWS table"
            end
            records = SchMatrixBreak.where(SCH_DATE: date, CHANNEL_CODE: channel_code, 
              DAY_PART: daypart, SIGNATURE: signature, MASTER_BREAK_NUM: sig_count)
            if records.size == 0
              s = SchMatrixBreak.create(SCH_DATE: date, CHANNEL_CODE: channel_code, 
                  DAY_PART: daypart, SIGNATURE: signature, FILE_NAME: "", 
                  MASTER_BREAK_NUM: sig_count, WIN_BEGIN: win_begin, WIN_END: win_end)
            else
              s = records.first
            end
            cities = rotate["cities"]
            cities.each { |city_code, city|
              captions = city["captions"]
              seq_in_break = 1
              captions.each do |caption|
                caption_id = caption["id"]
                ad_name = caption["ad_name"]
                caption_id = caption["id"]
                caption_name = caption["name"].nil? ? "" : caption["name"]
                caption_type = caption["type"]
                if caption_type == "filler"
                  caption_id = "000000000000"
                  caption_name = ad_name
                end
                duration = caption["duration"]
                SchMatrixLocalAd.create(SCH_MATRIX_BRK_ID: s.ID, CITY_CODE: city_code, 
                  SEQ_IN_BREAK: seq_in_break, CAPTION_ID: caption_id, AD_NAME: ad_name, 
                  CAPTION_NAME: caption_name, SCHEDULED_DURATION: duration)
                Schedule.create(SCH_DATE: date, CHANNEL_CODE: channel_code, 
                  CITY_CODE: city_code, CAPTION_ID: caption_id, BREAK_NUMBER: sig_count,
                  SEQ_IN_ISLAND: seq_in_break, CAMPAIGN_NAME: caption_name, DAY_PART: daypart, 
                  WIN_BEGIN: win_begin, WIN_END: win_end, AD_TYPE: 'LVA', PRELOAD_TIME: win_begin,
                  ISLAND_NUMBER: 1, INGEST_TYPE: 'NORMAL', SCHEDULED_DURATION: duration, 
                  PREROLL_TIME: 0, AD_NAME: ad_name)
                seq_in_break = seq_in_break+1
              end
            }
          end
        }
      }
      result = {}
      result[:status] = 0
      result[:result] = "success"
      render :json => result.to_json

      command = Rails.configuration.publish_command
      command = command.gsub '{channel_code}', channel_code
      command = command.gsub '{date}', date

      Rails.logger.info "Publishing: #{command}"
      `#{command}`
    rescue Exception => e
      result = {}
      result[:status] = 1
      result[:result] = e.message
      #puts e.backtrace
      render :json => result.to_json
    end
  end

  def get_caption_id_to_schedule_type_start_end_date_map(date)
    con = ActiveRecord::Base.connection

    query = File.read("sql/caption_id_to_schedule_type_start_end_date.sql")
    query.gsub! "{date}", date
    result = {}
    rows = con.exec_query(query)
    rows.each do |row|
      caption_id = row['caption_id']
      schedule_type = row['schedule_type']
      start_date = row['start_date']
      end_date = row['end_date']
      result[caption_id] = {
        'schedule_type' => schedule_type,
        'start_date' => start_date,
        'end_date' => end_date
      }
    end

    return result
  end

  def get_caption_id_to_schedule_type_map(date)
    con = ActiveRecord::Base.connection

    query = File.read("sql/caption_id_to_schedule_type.sql")
    query.gsub! "{date}", date
    result = {}
    rows = con.exec_query(query)
    rows.each do |row|
      caption_id = row['caption_id']
      schedule_type = row['schedule_type']
      result[caption_id] = schedule_type
    end

    return result
  end

  def get_caption_id_to_dp_to_rotate_map(filename, date, channel_code) 
    con = ActiveRecord::Base.connection

    query = File.read(filename)
    query.gsub! '{date}', date
    query.gsub! '{channel_code}', channel_code
    rows = con.exec_query(query)

    result = {}
    rows.each do |row|
      caption_id = row["caption_id"]
      daypart = row["day_part"]
      result[caption_id] ||= {}
      result[caption_id][daypart] = row["rotates"]
    end

    return result
  end

  def get_master_caption_id_to_city_array_map(date, channel_code)
    con = ActiveRecord::Base.connection
    
    filename = 'sql/master_campaign_to_city_array.sql'
    query = File.read(filename)
    query.gsub! '{date}', date
    query.gsub! '{channel_code}', channel_code
    rows = con.exec_query(query)

    result = {}
    rows.each do |row|
      caption_id = row["caption_id"]
      city_code = row["city_code"]
      cities = result[caption_id] || []
      cities.push city_code unless cities.include?(city_code)
      result[caption_id] = cities
    end

    return result
  end

  def get_daypart_to_signature_to_times_map(date, channel_code)
    con = ActiveRecord::Base.connection

    filename = 'sql/daypart_to_signature_to_times.sql'
    query = File.read(filename)
    query.gsub! '{date}', date
    query.gsub! '{channel_code}', channel_code
    rows = con.exec_query(query)

    result = {}
    rows.each do |row|
      daypart = row["day_part"]
      signature_id = row["signature_id"]
      start_time = row["playout_time"]
      result[daypart] = result[daypart] || {}
      result[daypart][signature_id] = result[daypart][signature_id] || []
      result[daypart][signature_id].push start_time
    end

    return result
  end

  def authenticate
    headers['Access-Control-Allow-Origin'] = '*'
    authenticate_or_request_with_http_basic('Administration') do |username, password|
      username == Rails.configuration.scheduling.username && password == Rails.configuration.scheduling.password
    end
  end
end
