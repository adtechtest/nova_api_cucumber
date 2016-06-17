#!/usr/bin/env ruby
require 'date'
require 'rubygems'
month_no=Time.now.strftime("%m")
month=Date.today.strftime("%B")
year=Time.now.year
filename="TBR-Beta/ReleaseOrder/ZT/#{year}/#{month_no}-#{month}/Zeetv_MasterRO_#{month}#{year}"

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
query="INSERT INTO AMAGI_REPORTS_DB.RO_CAMPAIGN_DETAILS (ID, CHANNEL_CODE, BRAND_NAME, START_DATE, END_DATE, RO_TYPE, ORDER_DATE, FILE_NAME, SHEET_NAME)
                  VALUES ('151532', 'ZT', 'A to Z', '#{start_date}', '#{end_date}', 'NEW', '2015-02-03', '#{filename}', 'R01');"
puts query
ActiveRecord::Base.connection.execute(query)

query="INSERT INTO AMAGI_REPORTS_DB.RO_SPOT_DETAILS (RO_CAMPAIGN_DETAILS_ID, SCH_DATE, DAY_PART_NAME, TIME_BAND_START, TIME_BAND_END, PREF_TIME_BAND_START, PREF_TIME_BAND_END, SIGNATURE, SPOT_DURATION, SPOT_COUNT)
                                      VALUES ('151532', '#{sch1_date}', 'Afternoon', '12:00:00', '15:59:00', '13:00:00', '14:00:00', 'ASTRM_01_020', '20', '1');"
puts query
ActiveRecord::Base.connection.execute(query)
query="INSERT INTO AMAGI_REPORTS_DB.RO_SPOT_DETAILS (RO_CAMPAIGN_DETAILS_ID, SCH_DATE, DAY_PART_NAME, TIME_BAND_START, TIME_BAND_END, PREF_TIME_BAND_START, PREF_TIME_BAND_END, SIGNATURE, SPOT_DURATION, SPOT_COUNT)
                                      VALUES ('151532', '#{sch1_date}', 'Evening', '16:00:00', '17:59:00', '17:00:00', '18:00:00', 'ASTRM_01_020', '20', '1');"
puts query
ActiveRecord::Base.connection.execute(query)
query="INSERT INTO AMAGI_REPORTS_DB.RO_SPOT_DETAILS (RO_CAMPAIGN_DETAILS_ID, SCH_DATE, DAY_PART_NAME, TIME_BAND_START, TIME_BAND_END, PREF_TIME_BAND_START, PREF_TIME_BAND_END, SIGNATURE, SPOT_DURATION, SPOT_COUNT)
                                      VALUES ('151532', '#{sch1_date}', 'Morning', '09:00:00', '11:59:00', '10:00:00', '11:00:00', 'ASTRM_01_020', '20', '1');"
puts query
ActiveRecord::Base.connection.execute(query)
query="INSERT INTO AMAGI_REPORTS_DB.RO_SPOT_DETAILS (RO_CAMPAIGN_DETAILS_ID, SCH_DATE, DAY_PART_NAME, TIME_BAND_START, TIME_BAND_END, PREF_TIME_BAND_START, PREF_TIME_BAND_END, SIGNATURE, SPOT_DURATION, SPOT_COUNT)
                                      VALUES ('151532', '#{sch1_date}', 'Night', '18:00:00', '23:29:00', '20:00:00', '22:00:00', 'ASTRM_01_020', '20', '1');"
puts query
ActiveRecord::Base.connection.execute(query)
query="INSERT INTO AMAGI_REPORTS_DB.RO_SPOT_DETAILS (RO_CAMPAIGN_DETAILS_ID, SCH_DATE, DAY_PART_NAME, TIME_BAND_START, TIME_BAND_END, PREF_TIME_BAND_START, PREF_TIME_BAND_END, SIGNATURE, SPOT_DURATION, SPOT_COUNT)
                                      VALUES ('151532', '#{sch2_date}', 'Afternoon', '12:00:00', '15:59:00', '13:00:00', '14:00:00', 'ASTRM_01_020', '20', '1');"
puts query
ActiveRecord::Base.connection.execute(query)
query="INSERT INTO AMAGI_REPORTS_DB.RO_SPOT_DETAILS (RO_CAMPAIGN_DETAILS_ID, SCH_DATE, DAY_PART_NAME, TIME_BAND_START, TIME_BAND_END, PREF_TIME_BAND_START, PREF_TIME_BAND_END, SIGNATURE, SPOT_DURATION, SPOT_COUNT)
                                      VALUES ('151532', '#{sch2_date}', 'Evening', '16:00:00', '17:59:00', '17:00:00', '18:00:00', 'ASTRM_01_020', '20', '1');"
puts query
ActiveRecord::Base.connection.execute(query)
query="INSERT INTO AMAGI_REPORTS_DB.RO_SPOT_DETAILS (RO_CAMPAIGN_DETAILS_ID, SCH_DATE, DAY_PART_NAME, TIME_BAND_START, TIME_BAND_END, PREF_TIME_BAND_START, PREF_TIME_BAND_END, SIGNATURE, SPOT_DURATION, SPOT_COUNT)
                                      VALUES ('151532', '#{sch2_date}', 'Morning', '09:00:00', '11:59:00', '10:00:00', '11:00:00', 'ASTRM_01_020', '20', '1');"
puts query
ActiveRecord::Base.connection.execute(query)
query="INSERT INTO AMAGI_REPORTS_DB.RO_SPOT_DETAILS (RO_CAMPAIGN_DETAILS_ID, SCH_DATE, DAY_PART_NAME, TIME_BAND_START, TIME_BAND_END, PREF_TIME_BAND_START, PREF_TIME_BAND_END, SIGNATURE, SPOT_DURATION, SPOT_COUNT)
                                      VALUES ('151532', '#{sch2_date}', 'Night', '18:00:00', '23:29:00', '20:00:00', '22:00:00', 'ASTRM_01_020', '20', '1');"
puts query
ActiveRecord::Base.connection.execute(query)
query="INSERT INTO AMAGI_REPORTS_DB.RO_SPOT_DETAILS (RO_CAMPAIGN_DETAILS_ID, SCH_DATE, DAY_PART_NAME, TIME_BAND_START, TIME_BAND_END, PREF_TIME_BAND_START, PREF_TIME_BAND_END, SIGNATURE, SPOT_DURATION, SPOT_COUNT)
                                      VALUES ('151532', '#{sch3_date}', 'Afternoon', '12:00:00', '15:59:00', '13:00:00', '14:00:00', 'ASTRM_01_020', '20', '1');"
puts query
ActiveRecord::Base.connection.execute(query)
query="INSERT INTO AMAGI_REPORTS_DB.RO_SPOT_DETAILS (RO_CAMPAIGN_DETAILS_ID, SCH_DATE, DAY_PART_NAME, TIME_BAND_START, TIME_BAND_END, PREF_TIME_BAND_START, PREF_TIME_BAND_END, SIGNATURE, SPOT_DURATION, SPOT_COUNT)
                                      VALUES ('151532', '#{sch3_date}', 'Evening', '16:00:00', '17:59:00', '17:00:00', '18:00:00', 'ASTRM_01_020', '20', '1');"
puts query
ActiveRecord::Base.connection.execute(query)
query="INSERT INTO AMAGI_REPORTS_DB.RO_SPOT_DETAILS (RO_CAMPAIGN_DETAILS_ID, SCH_DATE, DAY_PART_NAME, TIME_BAND_START, TIME_BAND_END, PREF_TIME_BAND_START, PREF_TIME_BAND_END, SIGNATURE, SPOT_DURATION, SPOT_COUNT)
                                      VALUES ('151532', '#{sch3_date}', 'Morning', '09:00:00', '11:59:00', '10:00:00', '11:00:00', 'ASTRM_01_020', '20', '1');"
puts query
ActiveRecord::Base.connection.execute(query)
query="INSERT INTO AMAGI_REPORTS_DB.RO_SPOT_DETAILS (RO_CAMPAIGN_DETAILS_ID, SCH_DATE, DAY_PART_NAME, TIME_BAND_START, TIME_BAND_END, PREF_TIME_BAND_START, PREF_TIME_BAND_END, SIGNATURE, SPOT_DURATION, SPOT_COUNT)
                                      VALUES ('151532', '#{sch3_date}', 'Night', '18:00:00', '23:29:00', '20:00:00', '22:00:00', 'ASTRM_01_020', '20', '1');"
puts query
ActiveRecord::Base.connection.execute(query)
query="INSERT INTO AMAGI_REPORTS_DB.RO_SPOT_DETAILS (RO_CAMPAIGN_DETAILS_ID, SCH_DATE, DAY_PART_NAME, TIME_BAND_START, TIME_BAND_END, PREF_TIME_BAND_START, PREF_TIME_BAND_END, SIGNATURE, SPOT_DURATION, SPOT_COUNT)
                                      VALUES ('151532', '#{sch4_date}', 'Afternoon', '12:00:00', '15:59:00', '13:00:00', '14:00:00', 'ASTRM_01_020', '20', '1');"
puts query
ActiveRecord::Base.connection.execute(query)
query="INSERT INTO AMAGI_REPORTS_DB.RO_SPOT_DETAILS (RO_CAMPAIGN_DETAILS_ID, SCH_DATE, DAY_PART_NAME, TIME_BAND_START, TIME_BAND_END, PREF_TIME_BAND_START, PREF_TIME_BAND_END, SIGNATURE, SPOT_DURATION, SPOT_COUNT)
                                      VALUES ('151532', '#{sch4_date}', 'Evening', '16:00:00', '17:59:00', '17:00:00', '18:00:00', 'ASTRM_01_020', '20', '1');"
puts query
ActiveRecord::Base.connection.execute(query)
query="INSERT INTO AMAGI_REPORTS_DB.RO_SPOT_DETAILS (RO_CAMPAIGN_DETAILS_ID, SCH_DATE, DAY_PART_NAME, TIME_BAND_START, TIME_BAND_END, PREF_TIME_BAND_START, PREF_TIME_BAND_END, SIGNATURE, SPOT_DURATION, SPOT_COUNT)
                                      VALUES ('151532', '#{sch4_date}', 'Morning', '09:00:00', '11:59:00', '10:00:00', '11:00:00', 'ASTRM_01_020', '20', '1');"
puts query
ActiveRecord::Base.connection.execute(query)
query="INSERT INTO AMAGI_REPORTS_DB.RO_SPOT_DETAILS (RO_CAMPAIGN_DETAILS_ID, SCH_DATE, DAY_PART_NAME, TIME_BAND_START, TIME_BAND_END, PREF_TIME_BAND_START, PREF_TIME_BAND_END, SIGNATURE, SPOT_DURATION, SPOT_COUNT)
                                      VALUES ('151532', '#{sch5_date}', 'Night', '18:00:00', '23:29:00', '20:00:00', '22:00:00', 'ASTRM_01_020', '20', '1');"
puts query
ActiveRecord::Base.connection.execute(query)                                   
                                      
puts "For second master signature"

query="INSERT IGNORE INTO AMAGI_REPORTS_DB.RO_CAMPAIGN_DETAILS (ID, CHANNEL_CODE, BRAND_NAME, START_DATE, END_DATE, RO_TYPE, ORDER_DATE, FILE_NAME, SHEET_NAME)
                   VALUES ('151533', 'ZT', 'A to Z', '#{start_date}', '#{end_date}', 'NEW', '2015-02-03', '#{filename}', 'R02');"
puts query
ActiveRecord::Base.connection.execute(query)        

query="INSERT INTO AMAGI_REPORTS_DB.RO_SPOT_DETAILS (RO_CAMPAIGN_DETAILS_ID, SCH_DATE, DAY_PART_NAME, TIME_BAND_START, TIME_BAND_END, PREF_TIME_BAND_START, PREF_TIME_BAND_END, SIGNATURE, SPOT_DURATION, SPOT_COUNT)
                                       VALUES ('151533', '#{sch1_date}', 'Afternoon', '12:00:00', '15:59:00', '13:00:00', '14:00:00', 'HYNDM_01_030', '30', '1');"
puts query
ActiveRecord::Base.connection.execute(query)        
query="INSERT INTO AMAGI_REPORTS_DB.RO_SPOT_DETAILS (RO_CAMPAIGN_DETAILS_ID, SCH_DATE, DAY_PART_NAME, TIME_BAND_START, TIME_BAND_END, PREF_TIME_BAND_START, PREF_TIME_BAND_END, SIGNATURE, SPOT_DURATION, SPOT_COUNT)
                                       VALUES ('151533', '#{sch1_date}', 'Evening', '16:00:00', '17:59:00', '17:00:00', '18:00:00', 'HYNDM_01_030', '30', '1');"
puts query
ActiveRecord::Base.connection.execute(query)        
query="INSERT INTO AMAGI_REPORTS_DB.RO_SPOT_DETAILS (RO_CAMPAIGN_DETAILS_ID, SCH_DATE, DAY_PART_NAME, TIME_BAND_START, TIME_BAND_END, PREF_TIME_BAND_START, PREF_TIME_BAND_END, SIGNATURE, SPOT_DURATION, SPOT_COUNT)
                                       VALUES ('151533', '#{sch1_date}', 'Morning', '09:00:00', '11:59:00', '10:00:00', '11:00:00', 'HYNDM_01_030', '30', '1');"
puts query
ActiveRecord::Base.connection.execute(query)                                          

query="INSERT INTO AMAGI_REPORTS_DB.RO_SPOT_DETAILS (RO_CAMPAIGN_DETAILS_ID, SCH_DATE, DAY_PART_NAME, TIME_BAND_START, TIME_BAND_END, PREF_TIME_BAND_START, PREF_TIME_BAND_END, SIGNATURE, SPOT_DURATION, SPOT_COUNT)
                                       VALUES ('151533', '#{sch2_date}', 'Night', '18:00:00', '23:29:00', '20:00:00', '22:00:00', 'HYNDM_01_030', '30', '1');"
puts query
ActiveRecord::Base.connection.execute(query)   

query="INSERT INTO AMAGI_REPORTS_DB.RO_SPOT_DETAILS (RO_CAMPAIGN_DETAILS_ID, SCH_DATE, DAY_PART_NAME, TIME_BAND_START, TIME_BAND_END, PREF_TIME_BAND_START, PREF_TIME_BAND_END, SIGNATURE, SPOT_DURATION, SPOT_COUNT) VALUES ('151533', '#{sch2_date}', 'Afternoon', '12:00:00', '15:59:00', '13:00:00', '14:00:00', 'HYNDM_01_030', '30', '1');"
puts query
ActiveRecord::Base.connection.execute(query)

query="INSERT INTO AMAGI_REPORTS_DB.RO_SPOT_DETAILS (RO_CAMPAIGN_DETAILS_ID, SCH_DATE, DAY_PART_NAME, TIME_BAND_START, TIME_BAND_END, PREF_TIME_BAND_START, PREF_TIME_BAND_END, SIGNATURE, SPOT_DURATION, SPOT_COUNT) VALUES ('151533', '#{sch2_date}', 'Evening', '16:00:00', '17:59:00', '17:00:00', '18:00:00', 'HYNDM_01_030', '30', '1');"
puts query
ActiveRecord::Base.connection.execute(query)

query="INSERT INTO AMAGI_REPORTS_DB.RO_SPOT_DETAILS (RO_CAMPAIGN_DETAILS_ID, SCH_DATE, DAY_PART_NAME, TIME_BAND_START, TIME_BAND_END, PREF_TIME_BAND_START, PREF_TIME_BAND_END, SIGNATURE, SPOT_DURATION, SPOT_COUNT) VALUES ('151533', '#{sch3_date}', 'Morning', '09:00:00', '11:59:00', '10:00:00', '11:00:00', 'HYNDM_01_030', '30', '1');"
puts query
ActiveRecord::Base.connection.execute(query)

query="INSERT INTO AMAGI_REPORTS_DB.RO_SPOT_DETAILS (RO_CAMPAIGN_DETAILS_ID, SCH_DATE, DAY_PART_NAME, TIME_BAND_START, TIME_BAND_END, PREF_TIME_BAND_START, PREF_TIME_BAND_END, SIGNATURE, SPOT_DURATION, SPOT_COUNT) VALUES ('151533', '#{sch3_date}', 'Night', '18:00:00', '23:29:00', '20:00:00', '22:00:00', 'HYNDM_01_030', '30', '1');"
puts query
ActiveRecord::Base.connection.execute(query)

query="INSERT INTO AMAGI_REPORTS_DB.RO_SPOT_DETAILS (RO_CAMPAIGN_DETAILS_ID, SCH_DATE, DAY_PART_NAME, TIME_BAND_START, TIME_BAND_END, PREF_TIME_BAND_START, PREF_TIME_BAND_END, SIGNATURE, SPOT_DURATION, SPOT_COUNT) VALUES ('151533', '#{sch3_date}', 'Afternoon', '12:00:00', '15:59:00', '13:00:00', '14:00:00', 'HYNDM_01_030', '30', '1');"
puts query
ActiveRecord::Base.connection.execute(query)

query="INSERT INTO AMAGI_REPORTS_DB.RO_SPOT_DETAILS (RO_CAMPAIGN_DETAILS_ID, SCH_DATE, DAY_PART_NAME, TIME_BAND_START, TIME_BAND_END, PREF_TIME_BAND_START, PREF_TIME_BAND_END, SIGNATURE, SPOT_DURATION, SPOT_COUNT) VALUES ('151533', '#{sch3_date}', 'Evening', '16:00:00', '17:59:00', '17:00:00', '18:00:00', 'HYNDM_01_030', '30', '1');"
puts query
ActiveRecord::Base.connection.execute(query)

query="INSERT INTO AMAGI_REPORTS_DB.RO_SPOT_DETAILS (RO_CAMPAIGN_DETAILS_ID, SCH_DATE, DAY_PART_NAME, TIME_BAND_START, TIME_BAND_END, PREF_TIME_BAND_START, PREF_TIME_BAND_END, SIGNATURE, SPOT_DURATION, SPOT_COUNT) VALUES ('151533', '#{sch4_date}', 'Morning', '09:00:00', '11:59:00', '10:00:00', '11:00:00', 'HYNDM_01_030', '30', '1');"
puts query
ActiveRecord::Base.connection.execute(query)

query="INSERT INTO AMAGI_REPORTS_DB.RO_SPOT_DETAILS (RO_CAMPAIGN_DETAILS_ID, SCH_DATE, DAY_PART_NAME, TIME_BAND_START, TIME_BAND_END, PREF_TIME_BAND_START, PREF_TIME_BAND_END, SIGNATURE, SPOT_DURATION, SPOT_COUNT) VALUES ('151533', '#{sch4_date}', 'Night', '18:00:00', '23:29:00', '20:00:00', '22:00:00', 'HYNDM_01_030', '30', '1');"
puts query
ActiveRecord::Base.connection.execute(query)

query="INSERT INTO AMAGI_REPORTS_DB.RO_SPOT_DETAILS (RO_CAMPAIGN_DETAILS_ID, SCH_DATE, DAY_PART_NAME, TIME_BAND_START, TIME_BAND_END, PREF_TIME_BAND_START, PREF_TIME_BAND_END, SIGNATURE, SPOT_DURATION, SPOT_COUNT) VALUES ('151533', '#{sch4_date}', 'Afternoon', '12:00:00', '15:59:00', '13:00:00', '14:00:00', 'HYNDM_01_030', '30', '1');"
puts query
ActiveRecord::Base.connection.execute(query)

query="INSERT INTO AMAGI_REPORTS_DB.RO_SPOT_DETAILS (RO_CAMPAIGN_DETAILS_ID, SCH_DATE, DAY_PART_NAME, TIME_BAND_START, TIME_BAND_END, PREF_TIME_BAND_START, PREF_TIME_BAND_END, SIGNATURE, SPOT_DURATION, SPOT_COUNT) VALUES ('151533', '#{sch4_date}', 'Evening', '16:00:00', '17:59:00', '17:00:00', '18:00:00', 'HYNDM_01_030', '30', '1');"
puts query
ActiveRecord::Base.connection.execute(query)

query="INSERT INTO AMAGI_REPORTS_DB.RO_SPOT_DETAILS (RO_CAMPAIGN_DETAILS_ID, SCH_DATE, DAY_PART_NAME, TIME_BAND_START, TIME_BAND_END, PREF_TIME_BAND_START, PREF_TIME_BAND_END, SIGNATURE, SPOT_DURATION, SPOT_COUNT) VALUES ('151533', '#{sch5_date}', 'Morning', '09:00:00', '11:59:00', '10:00:00', '11:00:00', 'HYNDM_01_030', '30', '1');"
puts query
ActiveRecord::Base.connection.execute(query)

query="INSERT INTO AMAGI_REPORTS_DB.RO_SPOT_DETAILS (RO_CAMPAIGN_DETAILS_ID, SCH_DATE, DAY_PART_NAME, TIME_BAND_START, TIME_BAND_END, PREF_TIME_BAND_START, PREF_TIME_BAND_END, SIGNATURE, SPOT_DURATION, SPOT_COUNT) VALUES ('151533', '#{sch5_date}', 'Night', '18:00:00', '23:29:00', '20:00:00', '22:00:00', 'HYNDM_01_030', '30', '1');"
puts query
ActiveRecord::Base.connection.execute(query)
