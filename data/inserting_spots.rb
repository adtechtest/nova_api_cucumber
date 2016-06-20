#!/usr/bin/env ruby
require 'date'
require 'rubygems'
month_no=Time.now.strftime("%m")
month=Date.today.strftime("%B")
year=Time.now.year
filename="TBR-Beta/ReleaseOrder/ZN/#{year}/#{month_no}-#{month}/ZEENEWS_MasterRO_#{month}#{year}"

start_date=(Time.now-2.day).strftime("%Y-%m-%d")
end_date=(Time.now+2.day).strftime("%Y-%m-%d")
sch1_date=Time.now.strftime("%Y-%m-%d")
sch2_date=(Time.now+1.day).strftime("%Y-%m-%d")
sch3_date=end_date
sch4_date=(Time.now-1.day).strftime("%Y-%m-%d")
sch5_date=start_date

## Queries for deleting old data
puts "Deleting old data from RO_SIGNATURE_CAPTIONS and RO_SPOT_DETAILS tables"
query="DELETE FROM AMAGI_REPORTS_DB.RO_SIGNATURE_CAPTIONS WHERE FILE_NAME = '#{filename}';"
puts query
ActiveRecord::Base.connection.execute(query)

query="DELETE FROM AMAGI_REPORTS_DB.RO_SPOT_DETAILS WHERE RO_CAMPAIGN_DETAILS_ID IN ( SELECT ID FROM AMAGI_REPORTS_DB.RO_CAMPAIGN_DETAILS WHERE FILE_NAME = '#{filename}');"
puts query
ActiveRecord::Base.connection.execute(query)

query="DELETE FROM AMAGI_REPORTS_DB.RO_CAMPAIGN_DETAILS WHERE FILE_NAME = '#{filename}';"
puts query
ActiveRecord::Base.connection.execute(query)

query="INSERT IGNORE INTO AMAGI_REPORTS_DB.RO_SIGNATURE_CAPTIONS (FILE_NAME, SIGNATURE, CAPTION_ID, SLOT_NUMBER) VALUES ('#{filename}','ASTRM_01_020','4NV1WRX2UTL3',1);"
puts query
ActiveRecord::Base.connection.execute(query)

query="INSERT IGNORE INTO AMAGI_REPORTS_DB.RO_SIGNATURE_CAPTIONS (FILE_NAME, SIGNATURE, CAPTION_ID, SLOT_NUMBER) VALUES ('#{filename}','HYNDM_01_030','6K1NHB2SWZWI',1);"
puts query
ActiveRecord::Base.connection.execute(query)

puts "Inserting new entries"
query="INSERT INTO AMAGI_REPORTS_DB.RO_CAMPAIGN_DETAILS (CHANNEL_CODE, BRAND_NAME, START_DATE, END_DATE, RO_TYPE, ORDER_DATE, FILE_NAME, SHEET_NAME)
                  VALUES ('ZN', 'A to Z', '#{start_date}', '#{end_date}', 'NEW', '2015-02-03', '#{filename}', 'R01');"
puts query
ActiveRecord::Base.connection.execute(query)

query="select ID as id from AMAGI_REPORTS_DB.RO_CAMPAIGN_DETAILS where CHANNEL_CODE='ZN' and BRAND_NAME='A to Z' and START_DATE='#{start_date}' and END_DATE='#{end_date}' and FILE_NAME='#{filename}';"
puts query
id=ActiveRecord::Base.connection.exec_query(query)
id=id[0]["id"]

query="INSERT INTO AMAGI_REPORTS_DB.RO_SPOT_DETAILS (RO_CAMPAIGN_DETAILS_ID, SCH_DATE, DAY_PART_NAME, TIME_BAND_START, TIME_BAND_END, PREF_TIME_BAND_START, PREF_TIME_BAND_END, SIGNATURE, SPOT_DURATION, SPOT_COUNT)
          VALUES ('#{id}', '#{sch1_date}', 'Rest of Day', '12:00:00', '15:59:00', '13:00:00', '14:00:00', 'ASTRM_01_020', '20', '1');"
puts query
ActiveRecord::Base.connection.execute(query)

query="INSERT INTO AMAGI_REPORTS_DB.EXPECTED_PLAYED_TIMES (SCH_DATE, CHANNEL_CODE, SIGNATURE, CAMPAIGN, START_TIME, END_TIME, PREFERRED_TIMEBAND_START, PREFERRED_TIMEBAND_END, PREFERRED_TIMEBAND_STATUS, TIMEBAND_START, TIMEBAND_END, TIMEBAND_STATUS, FILE_NAME)
          VALUES ('#{sch1_date}', 'ZN', 'ASTRM_01_020', 'Test Camp 1', '13:06:15', '13:26:15', '13:00:00', '14:00:00', 'Unallocated', '12:55:00', '14:00:00', 'Allocated', 'TBR-Beta/BroadcasterLogs/ZN/2016/ZeeNews_Logs.xls');"

puts query
ActiveRecord::Base.connection.execute(query)

query="INSERT INTO AMAGI_REPORTS_DB.RO_SPOT_DETAILS (RO_CAMPAIGN_DETAILS_ID, SCH_DATE, DAY_PART_NAME, TIME_BAND_START, TIME_BAND_END, PREF_TIME_BAND_START, PREF_TIME_BAND_END, SIGNATURE, SPOT_DURATION, SPOT_COUNT)
                                      VALUES ('#{id}', '#{sch1_date}', 'Morning', '09:00:00', '11:59:00', '10:00:00', '11:00:00', 'ASTRM_01_020', '20', '1');"
puts query
ActiveRecord::Base.connection.execute(query)

query="INSERT INTO AMAGI_REPORTS_DB.EXPECTED_PLAYED_TIMES (SCH_DATE, CHANNEL_CODE, SIGNATURE, CAMPAIGN, START_TIME, END_TIME, PREFERRED_TIMEBAND_START, PREFERRED_TIMEBAND_END, PREFERRED_TIMEBAND_STATUS, TIMEBAND_START, TIMEBAND_END, TIMEBAND_STATUS, FILE_NAME)
          VALUES ('#{sch1_date}', 'ZN', 'ASTRM_01_020', 'Test Camp 1', '10:21:00', '10:40:15', '10:00:00', '11:00:00', 'Unallocated', '09:55:00', '11:00:00', 'Allocated', 'TBR-Beta/BroadcasterLogs/ZN/2016/ZeeNews_Logs.xls');"

puts query
ActiveRecord::Base.connection.execute(query)

query="INSERT INTO AMAGI_REPORTS_DB.RO_SPOT_DETAILS (RO_CAMPAIGN_DETAILS_ID, SCH_DATE, DAY_PART_NAME, TIME_BAND_START, TIME_BAND_END, PREF_TIME_BAND_START, PREF_TIME_BAND_END, SIGNATURE, SPOT_DURATION, SPOT_COUNT)
                                      VALUES ('#{id}', '#{sch1_date}', 'Evening', '18:00:00', '23:29:00', '20:00:00', '22:00:00', 'ASTRM_01_020', '20', '1');"
puts query
ActiveRecord::Base.connection.execute(query)

query="INSERT INTO AMAGI_REPORTS_DB.EXPECTED_PLAYED_TIMES (SCH_DATE, CHANNEL_CODE, SIGNATURE, CAMPAIGN, START_TIME, END_TIME, PREFERRED_TIMEBAND_START, PREFERRED_TIMEBAND_END, PREFERRED_TIMEBAND_STATUS, TIMEBAND_START, TIMEBAND_END, TIMEBAND_STATUS, FILE_NAME)
          VALUES ('#{sch1_date}', 'ZN', 'ASTRM_01_020', 'Test Camp 1', '20:11:45', '20:30:47', '20:00:00', '21:00:00', 'Unallocated', '19:55:00', '21:00:00', 'Allocated', 'TBR-Beta/BroadcasterLogs/ZN/2016/ZeeNews_Logs.xls');"

puts query
ActiveRecord::Base.connection.execute(query)


query="INSERT INTO AMAGI_REPORTS_DB.RO_SPOT_DETAILS (RO_CAMPAIGN_DETAILS_ID, SCH_DATE, DAY_PART_NAME, TIME_BAND_START, TIME_BAND_END, PREF_TIME_BAND_START, PREF_TIME_BAND_END, SIGNATURE, SPOT_DURATION, SPOT_COUNT)
                                      VALUES ('#{id}', '#{sch2_date}', 'Rest of Day', '12:00:00', '15:59:00', '13:00:00', '14:00:00', 'ASTRM_01_020', '20', '1');"
puts query
ActiveRecord::Base.connection.execute(query)


query="INSERT INTO AMAGI_REPORTS_DB.RO_SPOT_DETAILS (RO_CAMPAIGN_DETAILS_ID, SCH_DATE, DAY_PART_NAME, TIME_BAND_START, TIME_BAND_END, PREF_TIME_BAND_START, PREF_TIME_BAND_END, SIGNATURE, SPOT_DURATION, SPOT_COUNT)
                                      VALUES ('#{id}', '#{sch2_date}', 'Morning', '09:00:00', '11:59:00', '10:00:00', '11:00:00', 'ASTRM_01_020', '20', '1');"
puts query
ActiveRecord::Base.connection.execute(query)

#query="INSERT INTO AMAGI_REPORTS_DB.EXPECTED_PLAYED_TIMES (SCH_DATE, CHANNEL_CODE, SIGNATURE, CAMPAIGN, START_TIME, END_TIME, PREFERRED_TIMEBAND_START, PREFERRED_TIMEBAND_END, PREFERRED_TIMEBAND_STATUS, TIMEBAND_START, TIMEBAND_END, TIMEBAND_STATUS, FILE_NAME)
#          VALUES ('#{today_date}', 'ZN', 'ASTRM_01_020', 'Test Camp 1', '07:28:55', '07:45:00', '07:00:00', '08:00:00', 'Unallocated', '07:55:00', '08:00:00', 'Allocated', 'TBR-Beta/BroadcasterLogs/ZN/2016/ZeeNews_Logs.xls');"

#puts query
#ActiveRecord::Base.connection.execute(query)

query="INSERT INTO AMAGI_REPORTS_DB.RO_SPOT_DETAILS (RO_CAMPAIGN_DETAILS_ID, SCH_DATE, DAY_PART_NAME, TIME_BAND_START, TIME_BAND_END, PREF_TIME_BAND_START, PREF_TIME_BAND_END, SIGNATURE, SPOT_DURATION, SPOT_COUNT)
                                      VALUES ('#{id}', '#{sch2_date}', 'Evening', '18:00:00', '23:29:00', '20:00:00', '22:00:00', 'ASTRM_01_020', '20', '1');"
puts query
ActiveRecord::Base.connection.execute(query)

#query="INSERT INTO AMAGI_REPORTS_DB.EXPECTED_PLAYED_TIMES (SCH_DATE, CHANNEL_CODE, SIGNATURE, CAMPAIGN, START_TIME, END_TIME, PREFERRED_TIMEBAND_START, PREFERRED_TIMEBAND_END, PREFERRED_TIMEBAND_STATUS, TIMEBAND_START, TIMEBAND_END, TIMEBAND_STATUS, FILE_NAME)
#          VALUES ('#{today_date}', 'ZN', 'ASTRM_01_020', 'Test Camp 1', '18:55:22', '19:06:24', '18:00:00', '20:00:00', 'Unallocated', '18:00:00', '20:00:00', 'Allocated', 'TBR-Beta/BroadcasterLogs/ZN/2016/ZeeNews_Logs.xls');"

#puts query
#ActiveRecord::Base.connection.execute(query)

query="INSERT INTO AMAGI_REPORTS_DB.RO_SPOT_DETAILS (RO_CAMPAIGN_DETAILS_ID, SCH_DATE, DAY_PART_NAME, TIME_BAND_START, TIME_BAND_END, PREF_TIME_BAND_START, PREF_TIME_BAND_END, SIGNATURE, SPOT_DURATION, SPOT_COUNT)
                                      VALUES ('#{id}', '#{sch3_date}', 'Rest of Day', '12:00:00', '15:59:00', '13:00:00', '14:00:00', 'ASTRM_01_020', '20', '1');"
puts query
ActiveRecord::Base.connection.execute(query)



query="INSERT INTO AMAGI_REPORTS_DB.RO_SPOT_DETAILS (RO_CAMPAIGN_DETAILS_ID, SCH_DATE, DAY_PART_NAME, TIME_BAND_START, TIME_BAND_END, PREF_TIME_BAND_START, PREF_TIME_BAND_END, SIGNATURE, SPOT_DURATION, SPOT_COUNT)
                                      VALUES ('#{id}', '#{sch3_date}', 'Morning', '09:00:00', '11:59:00', '10:00:00', '11:00:00', 'ASTRM_01_020', '20', '1');"
puts query
ActiveRecord::Base.connection.execute(query)
query="INSERT INTO AMAGI_REPORTS_DB.RO_SPOT_DETAILS (RO_CAMPAIGN_DETAILS_ID, SCH_DATE, DAY_PART_NAME, TIME_BAND_START, TIME_BAND_END, PREF_TIME_BAND_START, PREF_TIME_BAND_END, SIGNATURE, SPOT_DURATION, SPOT_COUNT)
                                      VALUES ('#{id}', '#{sch3_date}', 'Evening', '18:00:00', '23:29:00', '20:00:00', '22:00:00', 'ASTRM_01_020', '20', '1');"
puts query
ActiveRecord::Base.connection.execute(query)
query="INSERT INTO AMAGI_REPORTS_DB.RO_SPOT_DETAILS (RO_CAMPAIGN_DETAILS_ID, SCH_DATE, DAY_PART_NAME, TIME_BAND_START, TIME_BAND_END, PREF_TIME_BAND_START, PREF_TIME_BAND_END, SIGNATURE, SPOT_DURATION, SPOT_COUNT)
                                      VALUES ('#{id}', '#{sch4_date}', 'Rest of Day', '12:00:00', '15:59:00', '13:00:00', '14:00:00', 'ASTRM_01_020', '20', '1');"
puts query
ActiveRecord::Base.connection.execute(query)

query="INSERT INTO AMAGI_REPORTS_DB.RO_SPOT_DETAILS (RO_CAMPAIGN_DETAILS_ID, SCH_DATE, DAY_PART_NAME, TIME_BAND_START, TIME_BAND_END, PREF_TIME_BAND_START, PREF_TIME_BAND_END, SIGNATURE, SPOT_DURATION, SPOT_COUNT)
                                      VALUES ('#{id}', '#{sch4_date}', 'Morning', '09:00:00', '11:59:00', '10:00:00', '11:00:00', 'ASTRM_01_020', '20', '1');"
puts query
ActiveRecord::Base.connection.execute(query)
query="INSERT INTO AMAGI_REPORTS_DB.RO_SPOT_DETAILS (RO_CAMPAIGN_DETAILS_ID, SCH_DATE, DAY_PART_NAME, TIME_BAND_START, TIME_BAND_END, PREF_TIME_BAND_START, PREF_TIME_BAND_END, SIGNATURE, SPOT_DURATION, SPOT_COUNT)
                                      VALUES ('#{id}', '#{sch5_date}', 'Evening', '18:00:00', '23:29:00', '20:00:00', '22:00:00', 'ASTRM_01_020', '20', '1');"
puts query
ActiveRecord::Base.connection.execute(query)                                   
                                      
puts "For second master signature"

query="INSERT IGNORE INTO AMAGI_REPORTS_DB.RO_CAMPAIGN_DETAILS (CHANNEL_CODE, BRAND_NAME, START_DATE, END_DATE, RO_TYPE, ORDER_DATE, FILE_NAME, SHEET_NAME)
                   VALUES ('ZN', 'Test Brand', '#{start_date}', '#{end_date}', 'NEW', '2015-02-03', '#{filename}', 'R02');"
puts query
ActiveRecord::Base.connection.execute(query)        

query="select ID as id from AMAGI_REPORTS_DB.RO_CAMPAIGN_DETAILS where CHANNEL_CODE='ZN' and BRAND_NAME='Test Brand' and START_DATE='#{start_date}' and END_DATE='#{end_date}' and FILE_NAME='#{filename}';"
puts query
id=ActiveRecord::Base.connection.exec_query(query)
id=id[0]["id"]

query="INSERT INTO AMAGI_REPORTS_DB.RO_SPOT_DETAILS (RO_CAMPAIGN_DETAILS_ID, SCH_DATE, DAY_PART_NAME, TIME_BAND_START, TIME_BAND_END, PREF_TIME_BAND_START, PREF_TIME_BAND_END, SIGNATURE, SPOT_DURATION, SPOT_COUNT)
                                       VALUES ('#{id}', '#{sch1_date}', 'Rest of Day', '12:00:00', '15:59:00', '13:00:00', '14:00:00', 'HYNDM_01_030', '30', '1');"
puts query
ActiveRecord::Base.connection.execute(query)  

query="INSERT INTO AMAGI_REPORTS_DB.EXPECTED_PLAYED_TIMES (SCH_DATE, CHANNEL_CODE, SIGNATURE, CAMPAIGN, START_TIME, END_TIME, PREFERRED_TIMEBAND_START, PREFERRED_TIMEBAND_END, PREFERRED_TIMEBAND_STATUS, TIMEBAND_START, TIMEBAND_END, TIMEBAND_STATUS, FILE_NAME)
          VALUES ('#{sch1_date}', 'ZN', 'HYNDM_01_030', 'Test Camp 2', '13:11:52', '13:26:47', '13:00:00', '14:00:00', 'Unallocated', '13:00:00', '14:00:00', 'Allocated', 'TBR-Beta/BroadcasterLogs/ZN/2016/ZeeNews_Logs.xls');"

puts query
ActiveRecord::Base.connection.execute(query)

query="INSERT INTO AMAGI_REPORTS_DB.EXPECTED_PLAYED_TIMES (SCH_DATE, CHANNEL_CODE, SIGNATURE, CAMPAIGN, START_TIME, END_TIME, PREFERRED_TIMEBAND_START, PREFERRED_TIMEBAND_END, PREFERRED_TIMEBAND_STATUS, TIMEBAND_START, TIMEBAND_END, TIMEBAND_STATUS, FILE_NAME)
          VALUES ('#{sch1_date}', 'ZN', 'HYNDM_01_030', 'Test Camp 2', '19:28:00', '19:54:47', '19:00:00', '20:00:00', 'Unallocated', '19:00:00', '20:00:00', 'Allocated', 'TBR-Beta/BroadcasterLogs/ZN/2016/ZeeNews_Logs.xls');"

puts query
ActiveRecord::Base.connection.execute(query)

query="INSERT INTO AMAGI_REPORTS_DB.RO_SPOT_DETAILS (RO_CAMPAIGN_DETAILS_ID, SCH_DATE, DAY_PART_NAME, TIME_BAND_START, TIME_BAND_END, PREF_TIME_BAND_START, PREF_TIME_BAND_END, SIGNATURE, SPOT_DURATION, SPOT_COUNT)
                                       VALUES ('#{id}', '#{sch1_date}', 'Morning', '09:00:00', '11:59:00', '10:00:00', '11:00:00', 'HYNDM_01_030', '30', '1');"
puts query
ActiveRecord::Base.connection.execute(query)                                          

query="INSERT INTO AMAGI_REPORTS_DB.EXPECTED_PLAYED_TIMES (SCH_DATE, CHANNEL_CODE, SIGNATURE, CAMPAIGN, START_TIME, END_TIME, PREFERRED_TIMEBAND_START, PREFERRED_TIMEBAND_END, PREFERRED_TIMEBAND_STATUS, TIMEBAND_START, TIMEBAND_END, TIMEBAND_STATUS, FILE_NAME)
          VALUES ('#{sch1_date}', 'ZN', 'HYNDM_01_030', 'Test Camp 2', '09:11:52', '09:26:47', '09:00:00', '10:00:00', 'Unallocated', '09:00:00', '10:00:00', 'Allocated', 'TBR-Beta/BroadcasterLogs/ZN/2016/ZeeNews_Logs.xls');"

puts query
ActiveRecord::Base.connection.execute(query)


query="INSERT INTO AMAGI_REPORTS_DB.RO_SPOT_DETAILS (RO_CAMPAIGN_DETAILS_ID, SCH_DATE, DAY_PART_NAME, TIME_BAND_START, TIME_BAND_END, PREF_TIME_BAND_START, PREF_TIME_BAND_END, SIGNATURE, SPOT_DURATION, SPOT_COUNT)
                                       VALUES ('#{id}', '#{sch2_date}', 'Evening', '18:00:00', '23:29:00', '20:00:00', '22:00:00', 'HYNDM_01_030', '30', '1');"
puts query
ActiveRecord::Base.connection.execute(query)   

query="INSERT INTO AMAGI_REPORTS_DB.RO_SPOT_DETAILS (RO_CAMPAIGN_DETAILS_ID, SCH_DATE, DAY_PART_NAME, TIME_BAND_START, TIME_BAND_END, PREF_TIME_BAND_START, PREF_TIME_BAND_END, SIGNATURE, SPOT_DURATION, SPOT_COUNT) VALUES ('#{id}', '#{sch2_date}', 'Rest of Day', '12:00:00', '15:59:00', '13:00:00', '14:00:00', 'HYNDM_01_030', '30', '1');"
puts query
ActiveRecord::Base.connection.execute(query)

query="INSERT INTO AMAGI_REPORTS_DB.RO_SPOT_DETAILS (RO_CAMPAIGN_DETAILS_ID, SCH_DATE, DAY_PART_NAME, TIME_BAND_START, TIME_BAND_END, PREF_TIME_BAND_START, PREF_TIME_BAND_END, SIGNATURE, SPOT_DURATION, SPOT_COUNT) VALUES ('#{id}', '#{sch3_date}', 'Morning', '09:00:00', '11:59:00', '10:00:00', '11:00:00', 'HYNDM_01_030', '30', '1');"
puts query
ActiveRecord::Base.connection.execute(query)

query="INSERT INTO AMAGI_REPORTS_DB.RO_SPOT_DETAILS (RO_CAMPAIGN_DETAILS_ID, SCH_DATE, DAY_PART_NAME, TIME_BAND_START, TIME_BAND_END, PREF_TIME_BAND_START, PREF_TIME_BAND_END, SIGNATURE, SPOT_DURATION, SPOT_COUNT) VALUES ('#{id}', '#{sch3_date}', 'Evening', '18:00:00', '23:29:00', '20:00:00', '22:00:00', 'HYNDM_01_030', '30', '1');"
puts query
ActiveRecord::Base.connection.execute(query)

query="INSERT INTO AMAGI_REPORTS_DB.RO_SPOT_DETAILS (RO_CAMPAIGN_DETAILS_ID, SCH_DATE, DAY_PART_NAME, TIME_BAND_START, TIME_BAND_END, PREF_TIME_BAND_START, PREF_TIME_BAND_END, SIGNATURE, SPOT_DURATION, SPOT_COUNT) VALUES ('#{id}', '#{sch3_date}', 'Rest of Day', '12:00:00', '15:59:00', '13:00:00', '14:00:00', 'HYNDM_01_030', '30', '1');"
puts query
ActiveRecord::Base.connection.execute(query)

query="INSERT INTO AMAGI_REPORTS_DB.RO_SPOT_DETAILS (RO_CAMPAIGN_DETAILS_ID, SCH_DATE, DAY_PART_NAME, TIME_BAND_START, TIME_BAND_END, PREF_TIME_BAND_START, PREF_TIME_BAND_END, SIGNATURE, SPOT_DURATION, SPOT_COUNT) VALUES ('#{id}', '#{sch4_date}', 'Morning', '09:00:00', '11:59:00', '10:00:00', '11:00:00', 'HYNDM_01_030', '30', '1');"
puts query
ActiveRecord::Base.connection.execute(query)

query="INSERT INTO AMAGI_REPORTS_DB.RO_SPOT_DETAILS (RO_CAMPAIGN_DETAILS_ID, SCH_DATE, DAY_PART_NAME, TIME_BAND_START, TIME_BAND_END, PREF_TIME_BAND_START, PREF_TIME_BAND_END, SIGNATURE, SPOT_DURATION, SPOT_COUNT) VALUES ('#{id}', '#{sch4_date}', 'Evening', '18:00:00', '23:29:00', '20:00:00', '22:00:00', 'HYNDM_01_030', '30', '1');"
puts query
ActiveRecord::Base.connection.execute(query)

query="INSERT INTO AMAGI_REPORTS_DB.RO_SPOT_DETAILS (RO_CAMPAIGN_DETAILS_ID, SCH_DATE, DAY_PART_NAME, TIME_BAND_START, TIME_BAND_END, PREF_TIME_BAND_START, PREF_TIME_BAND_END, SIGNATURE, SPOT_DURATION, SPOT_COUNT) VALUES ('#{id}', '#{sch4_date}', 'Rest of Day', '12:00:00', '15:59:00', '13:00:00', '14:00:00', 'HYNDM_01_030', '30', '1');"
puts query
ActiveRecord::Base.connection.execute(query)

query="INSERT INTO AMAGI_REPORTS_DB.RO_SPOT_DETAILS (RO_CAMPAIGN_DETAILS_ID, SCH_DATE, DAY_PART_NAME, TIME_BAND_START, TIME_BAND_END, PREF_TIME_BAND_START, PREF_TIME_BAND_END, SIGNATURE, SPOT_DURATION, SPOT_COUNT) VALUES ('#{id}', '#{sch5_date}', 'Morning', '09:00:00', '11:59:00', '10:00:00', '11:00:00', 'HYNDM_01_030', '30', '1');"
puts query
ActiveRecord::Base.connection.execute(query)

query="INSERT INTO AMAGI_REPORTS_DB.RO_SPOT_DETAILS (RO_CAMPAIGN_DETAILS_ID, SCH_DATE, DAY_PART_NAME, TIME_BAND_START, TIME_BAND_END, PREF_TIME_BAND_START, PREF_TIME_BAND_END, SIGNATURE, SPOT_DURATION, SPOT_COUNT) VALUES ('#{id}', '#{sch5_date}', 'Evening', '18:00:00', '23:29:00', '20:00:00', '22:00:00', 'HYNDM_01_030', '30', '1');"
puts query
ActiveRecord::Base.connection.execute(query)
