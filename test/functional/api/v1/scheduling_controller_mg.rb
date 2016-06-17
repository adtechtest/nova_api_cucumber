require 'test_helper'

class Api::V1::SchedulingControllerTest < ActionController::TestCase
  self.use_transactional_fixtures = false

  test "verify makegood" do
    caption_id = "cap1"
    campaign_id = "camp1"
    deal_id = "deal1"
    channel_code = "ZT"
    city_code = "BA"
    day_part = "Morning"
  
    file_path = "test/data/mg2.json"
    json_array = JSON.parse(File.read(file_path))

    map = {}
    for i in -10..10
      date = Date.today + i.days
      map[i.to_s] = date.strftime("%Y-%m-%d")
    end

    con = ActiveRecord::Base.connection
    json_array.each do |json|
      plan = json["plan"]
      schedule = json["schedule"]
      asrun = json["asrun"]
      makegood = json["makegood"]
      end_date = json["end_date"].to_s
      Api::V1::SchedulingControllerTest.delete_data(con, caption_id)
      Api::V1::SchedulingControllerTest.load_data(con, caption_id, campaign_id, deal_id, channel_code, city_code, day_part, plan, schedule, asrun, map[end_date]) 
      makegood.each { |key, expected| 
        date = map[key]
        post(:planned_locals, {'date' => date, 'channel_code' => channel_code})
        assert_response :success
        body = JSON.parse(response.body)
        found = false
        planned_locals = body["planned_locals"]
        planned_locals.each do |planned_local|
          caption_id2 = planned_local["caption_id"]
          channel_code2 = planned_local["channel_code"]
          day_part2 = planned_local["daypart"]
          actual = planned_local["makegoods"]
          if caption_id == caption_id2 and channel_code == channel_code2 and day_part == day_part2
            print planned_local, "\n"
            found = true
            assert_equal expected, actual
          end
        end
        assert_equal true, found
      }
    end
  end

  def self.load_data(con, caption_id, campaign_id, deal_id, channel_code, city_code, day_part, plan, schedule, asrun, end_date)
    map = {}
    for i in -10..10
      date = Date.today + i.days
      map[i.to_s] = date.strftime("%Y-%m-%d")
    end
    plan.each { |key, rotates|
      date = map[key]
      query = Api::V1::SchedulingControllerTest.get_insert_rotate_plan_query(caption_id, channel_code, city_code, date, day_part, rotates)
      con.execute(query)
    }
    schedule.each { |key, rotates|
      date = map[key]
      for i in 1..rotates
        query = Api::V1::SchedulingControllerTest.get_insert_schedule_query(caption_id, channel_code, city_code, date, day_part)
        con.execute(query)
      end
    }
    asrun.each { |key, rotates|
      date = map[key]
      query = Api::V1::SchedulingControllerTest.get_insert_as_play_status_query(caption_id, channel_code, city_code, date, day_part, rotates)
      con.execute(query)
    }
    query = Api::V1::SchedulingControllerTest.get_insert_campaign_query(campaign_id, end_date)
    con.execute(query)
  end

  def self.delete_data(con, caption_id)
    query = Api::V1::SchedulingControllerTest.get_delete_rotate_plan_query(caption_id)
    con.execute(query)
    query = Api::V1::SchedulingControllerTest.get_delete_as_play_status_query(caption_id)
    con.execute(query)
    query = Api::V1::SchedulingControllerTest.get_delete_schedule_query(caption_id)
    con.execute(query)
  end

  def self.get_insert_rotate_plan_query(caption_id, channel_code, city_code, rotate_date, day_part, rotates)
    return "insert into AMAGI_REPORTS_DB.ATS_ROTATE_PLANS " + 
      "(CAPTION_ID, CHANNEL_CODE, CITY_CODE, ROTATE_DATE, DAY_PART, ROTATES) VALUES " + 
      "('#{caption_id}', '#{channel_code}', '#{city_code}', '#{rotate_date}', '#{day_part}', #{rotates});"
  end

  def self.get_insert_schedule_query(caption_id, channel_code, city_code, rotate_date, day_part)
    return "insert into AMAGI_REPORTS_DB.SCHEDULES " + 
      "(CAPTION_ID, CHANNEL_CODE, CITY_CODE, SCH_DATE, DAY_PART, AD_TYPE, " +
      "WIN_BEGIN, WIN_END, PRELOAD_TIME, BREAK_NUMBER, ISLAND_NUMBER, " +
      "SEQ_IN_ISLAND, PREROLL_TIME, AD_NAME, CAMPAIGN_NAME) VALUES " + 
      "('#{caption_id}', '#{channel_code}', '#{city_code}', '#{rotate_date}', " +
      "'#{day_part}', 'LVA', '06:00:00', '11:59:59', '00:00:00', 1, 1, 1, 0, " + 
      "'ABC110', 'Abc');"
  end

  def self.get_insert_as_play_status_query(caption_id, channel_code, city_code, rotate_date, day_part, rotates)
    return "insert into AMAGI_REPORTS_DB.AD_PLAY_STATUSES " +
      "(CAPTION_ID, CHANNEL_CODE, CITY_CODE, DATE, DAYPART, PLAYED_ROTATES) VALUES " +
      "('#{caption_id}', '#{channel_code}', '#{city_code}', '#{rotate_date}', '#{day_part}', #{rotates});"
  end

  def self.get_delete_rotate_plan_query(caption_id)
    return "delete from AMAGI_REPORTS_DB.ATS_ROTATE_PLANS " +
      "where caption_id = '#{caption_id}'"
  end

  def self.get_delete_as_play_status_query(caption_id)
    return "delete from AMAGI_REPORTS_DB.AD_PLAY_STATUSES " +
      "where caption_id = '#{caption_id}'"
  end

  def self.get_delete_schedule_query(caption_id)
    return "delete from AMAGI_REPORTS_DB.SCHEDULES " +
      "where caption_id = '#{caption_id}'"
  end

  def self.get_insert_campaign_query(campaign_id, valid_till)
    return "insert ignore into AMAGI_REPORTS_DB.ATS_CAMPAIGNS (campaign_id, valid_till) " + 
      "values ('#{campaign_id}', '#{valid_till}') on duplicate key update valid_till = '#{valid_till}'"
  end
end
