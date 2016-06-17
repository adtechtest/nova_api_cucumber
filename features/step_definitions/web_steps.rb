require 'uri'
require 'cgi'
require 'mysql2'
require 'net/http'
require 'httparty'
require "active_record"
require 'active_support/all'
require 'test/unit'
require 'test/unit/assertions'
require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))
include Test::Unit::Assertions

Before do |scenario|
  puts "Starting scenario"
end

After do |scenario|
  puts "Done scenario"
end


######
# My tests
######

When(/^I create local deal using XML file "([^"]*)"$/) do |file|
  _dbcliScript="/usr/amagi/DBCli/databaseupdater.sh"
  status = system("'#{_dbcliScript}' -F deal -a insert -r '#{file}'")
  Test::Unit::Assertions.assert_equal status, true
end

When(/^I "([^"]*)" local deal using XML file for "([^"]*)"$/) do |operation, channel|
  pwd=Dir.pwd
  file=pwd+"/data/3U0M1TEZM3EO.xml"
  dbcliScript="/usr/amagi/DBCli/databaseupdater.sh"
  #dbcliScript="/Users/csaikia/nova/DBCli/databaseupdater.sh"
  puts "Executing: #{dbcliScript} -F deal -a delete -r #{file}"
  system("#{dbcliScript} -F deal -a delete -r #{file}")
  system("#{dbcliScript} -F deal -a delete #{file}")
  
  if operation == "insert"
    puts "Executing: #{dbcliScript} -F deal -a #{operation} -r #{file}"
    status = system("#{dbcliScript} -F deal -a #{operation} -r #{file}")
  else
    system("#{dbcliScript} -F deal -a delete -r #{file}")
    status=system("#{dbcliScript} -F deal -a delete #{file}")
  end
  Test::Unit::Assertions.assert_equal status, true
end

Then(/^the response should "([^"]*)" deal info for "([^"]*)" and channel "([^"]*)"$/) do |operation, api, channel|
  if api == "LOCAL_CAPTIONS"
    time=Time.now.strftime("%Y-%m-%d")
    url="http://localhost:3000/api/v1/channels/#{channel}/local_captions.json?date="+time
    response=HTTParty.get(url)
    response=response["captions"]
    require 'crack'
    file=Dir.pwd+"/data/3U0M1TEZM3EO.xml"
    myXML = Crack::XML.parse(File.read("#{file}"))
    campaign_info=myXML["Deal"]["Campaign"]
    caption_info=myXML["Deal"]["Campaign"]["Caption"]
    puts "Storing information from the file"
    puts "Storing caption Id"
    caption_id=caption_info["Id"]
    puts caption_id
    puts "Storing campaign ID" 
    campaign_id=campaign_info["Id"]
    puts campaign_id
    puts "Storing name"
    name=campaign_info["Name"]
    puts name
    puts "Storing duration"
    duration=caption_info["CaptionDuration"]
    puts duration
    puts "Storing client_name"
    client_name=myXML["Deal"]["Client"]["Name"]
    puts client_name
    puts "Storing ad_name"
    ad_name=caption_info["AdName"]
    puts ad_name
    puts "Storing schedule_type"
    schedule_type=caption_info["ScheduleType"]
    puts schedule_type
    puts "Storing brand_name"
    brand_name=campaign_info["BrandName"]
    puts brand_name
    puts "Storing dayparts"
    parts=caption_info["ClientSecondages"]["ChannelSecondages"]
    dayparts=[]
    parts.each do |part|
      one_part=part["DayPart"]["Name"]
      dayparts.insert(-1,one_part)
    end
    puts dayparts
    puts "Storing city"
    city=campaign_info["City"]
    query_citycode="select CODE from MSO_DB.CITIES where NAME='#{city}';"
    city_code=ActiveRecord::Base.connection.exec_query(query_citycode)
    city_code=city_code[0]["CODE"]
    puts city_code
    if operation == "insert"
      flag=1
      response.each do |r|
        puts "From table"
        puts r["id"]
        puts r["campaign_id"]
        puts r["name"]
        puts r["duration"]
        puts r["client_name"]
        puts r["brand_name"]
        puts r["ad_name"] 
        puts r["schedule_type"] 
        puts r["city"] 
        if r["id"] == caption_id 
          puts "Caption ID match"
        end
        if r["campaign_id"] == campaign_id 
          puts "Campaign ID match"
        end
        
        if r["name"] == name 
          puts "Name match"
        end
        if r["duration"] == duration
          puts "Duration match" 
        end
        if r["client_name"] == client_name 
          puts "Client name match"
        end
        if r["brand_name"] == brand_name 
          puts "Brand name match"
        end
        if r["ad_name"] == ad_name && r["schedule_type"] == schedule_type && r["city"] == city_code
          puts "Now matching dayparts"
          dayparts_response=r["rates"].keys
          puts dayparts_response
          if dayparts.sort == dayparts_response.sort
            puts "Found inserted deal!"
            flag=0
          end
        end
      end
      Test::Unit::Assertions.assert_equal(flag,0)
            
    elsif operation == "delete"
      flag=0
      response.each do |r|
        if r["caption_id"] == caption_id
          flag=1
          break
        end
      end
      Test::Unit::Assertions.assert_equal(flag,0)
    end
    end
end

Then(/^the JSON response should include:$/) do |json|
  data_hash=JSON.parse(json)
  b=JSON.parse(@response.body)
#  entries=['name', 'ad_name', 'duration', 'campaign_id']
# entries.each do |entry|
  dealname_output=b["captions"].find{|b1| b1['id']=='33XIDIGLU8XT'}['name']
  dealname_test=data_hash['name']
  assert_match(dealname_test,dealname_output)
  #assert_equal(dealname_test,dealname_output)
  adname_output=b["captions"].find{|b1| b1['id']=='33XIDIGLU8XT'}['ad_name']
  adname_test=data_hash['ad_name']
  assert_match(adname_test,adname_output)
  duration_output=b["captions"].find{|b1| b1['id']=='33XIDIGLU8XT'}['duration']
  duration_test=data_hash['duration'] #.delete! '\\'
  #assert_match(duration_test,duration_output)
  campaign_id_output=b["captions"].find{|b1| b1['id']=='33XIDIGLU8XT'}['campaign_id']
  campaign_id_test=data_hash['campaign_id']
  assert_match(campaign_id_test,campaign_id_output)
  schedule_type_output=b["captions"].find{|b1| b1['id']=='33XIDIGLU8XT'}['schedule_type']
  schedule_type_test=data_hash['schedule_type']
  assert_match(schedule_type_test,schedule_type_output)
  client_name_output=b["captions"].find{|b1| b1['id']=='33XIDIGLU8XT'}['client_name']
  client_name_test=data_hash['client_name']
  assert_match(client_name_output,client_name_test)
  brand_name_output=b["captions"].find{|b1| b1['id']=='33XIDIGLU8XT'}['brand_name']
  brand_name_test=data_hash['brand_name'].delete! '\\'
  assert_no_match(brand_name_output,brand_name_test)
  rates_evening_output=b["captions"].find{|b1| b1['id']=='33XIDIGLU8XT'}['rates']['Evening']
  rates_evening_test=data_hash['rates']['Evening']
  assert_equal rates_evening_output, rates_evening_test
  rates_morning_output=b["captions"].find{|b1| b1['id']=='33XIDIGLU8XT'}['rates']['Morning']
  rates_morning_test=data_hash['rates']['Morning']
  assert_equal rates_morning_output, rates_morning_test
  rates_rod_output=b["captions"].find{|b1| b1['id']=='33XIDIGLU8XT'}['rates']['Rest of Day']
  rates_rod_test=data_hash['rates']['Rest of Day']
  assert_equal rates_rod_test,rates_rod_output
  city_output=b["captions"].find{|b1| b1['id']=='33XIDIGLU8XT'}['city']
  city_test=data_hash['city']
  assert_equal city_output, city_test
  
end

Then(/^the response for GET "([^"]*)" should have status "([^"]*)"$/) do |url, status|
  puts "Checking response for GET #{url}"
  res=Net::HTTP.get_response(URI(url))
  Test::Unit::Assertions.assert_equal(res.code,status)
end

Given(/^I use "([^"]*)" database and query "([^"]*)" table and set "([^"]*)" as "([^"]*)" for "([^"]*)"$/) do |db_name, table_name, property, value, field|
  #case table_name
  #when CHANNELS
    #if value == "null"
    #  query="update #{db_name}.#{table_name} set #{property}=NULL"
   # end

  if value == "past date"
    valid_till_date=Time.now - 10.day
  elsif value == "future date"
    valid_till_date=Time.now + 10.day
  else
    valid_till_date=nil
  end
  
  if !valid_till_date.nil? 
    valid_till=valid_till_date.strftime("%Y-%m-%d")
  end

  if field == "all"
    if value  == "null"
      query="update #{db_name}.#{table_name} set #{property}=NULL"
    else
      query="update #{db_name}.#{table_name} set #{property}='#{valid_till}'"
    end
  else
    if value == "null"
      if table_name == "FILLER_CAPTIONS"
        query="update #{db_name}.#{table_name} set #{property}=NULL where CHANNEL_ID='#{field}'"
      elsif table_name == "CHANNELS"
        query="update #{db_name}.#{table_name} set #{property}=NULL where CODE='#{field}'"
      elsif table_name == "CITIES"
        query="update #{db_name}.#{table_name} set #{property}=NULL where NAME='#{field}'"
      end
    else
      if table_name == "FILLER_CAPTIONS"
        query="update #{db_name}.#{table_name} set #{property}='#{valid_till}' where CHANNEL_ID='#{field}'"
      elsif table_name == "CHANNELS"
        query="update #{db_name}.#{table_name} set #{property}='#{valid_till}' where CODE='#{field}'"
      elsif table_name == "CITIES"
        query="update #{db_name}.#{table_name} set #{property}='#{valid_till}' where NAME='#{field}'"
      end
    end
  end
  
  puts "Executing query #{query}....."
  ActiveRecord::Base.connection.execute(query)
end


Then(/^output of "([^"]*)" table and "([^"]*)" should match$/) do |table_name, url|
  if table_name == "CHANNELS"
    query="select CODE,NAME from MSO_DB.#{table_name} order by NAME"
  end
  # Database output is in array
  puts "Executing query #{query}" 
  puts "Checking the response of #{query}"
  
  res=ActiveRecord::Base.connection.execute(query)
  # Get JSON output in hash form
  puts "Checking response of URL #{url}"
  @response = HTTParty.get(url)
  body=JSON.parse(@response.body)
  json_array=body.to_a
  channels=json_array[1]
  channels_list=channels[1]
  i=0
  puts "Comparing response from #{url} and query execution #{query}"
  res.each do |output|
    #output is an array having 1st element as code and 2nd element as channel name
    #channels_list is an array as well
    #Access to a channel can be made by channels_list[i] and then that
    # output needs to be matched for both channel name and code
    codename=channels_list[i]
    codenamearray=codename.to_a
    codearray=codenamearray[0]
    namearray=codenamearray[1]
    code=codearray[1]
    name=namearray[1]
    code.should == output[0]
    name.should == output[1]
    i+=1
  end
end

###CITIES###

Given(/^I use "([^"]*)" database and query "([^"]*)" table$/) do |db_name, table_name|
## Checking connection with database and check if table exists
  require './config/environment.rb' # Assuming the script is located in the root of the rails app
  tables=table_name.split(",")
  tables.each do |table|
    begin
      puts "Checking connection of database #{db_name} and table #{table}"
      ActiveRecord::Base.establish_connection # Establishes connection
      ActiveRecord::Base.connection # Calls connection object
      ActiveRecord::Base.connection.execute("desc #{db_name}.#{table}")
      puts "CONNECTED!" if ActiveRecord::Base.connected? 
      puts "NOT CONNECTED!" unless ActiveRecord::Base.connected?
    rescue
      puts "NOT CONNECTED!"
    end
  end
end

When(/^I use "([^"]*)" database and query "([^"]*)" table and "([^"]*)" new valid "([^"]*)"$/) do |db_name, table_name, operation, property|
  # Modify database
  valid_till=Time.now + 100.day
  valid_from=Time.now - 100.day
  valid_till_date=valid_till.strftime("%Y-%m-%d")
  valid_from_date=valid_from.strftime("%Y-%m-%d")
  puts db_name, table_name, property, operation
  if table_name == "CITIES" && db_name == "MSO_DB" 
    if property == "CITY"
      if operation == "add"
        query="insert into #{db_name}.#{table_name}(NAME,CODE,POPULATION,C_AND_S_COVERAGE,VALID_FROM,VALID_TO,STATE,DIGITAL_PENETRATION,STATUS,STB,CITY_TYPE,APPROVED_BY,APPROVED_ON,TYPE,REGION_ID) VALUES('Test City','TST','10000','100.00','#{valid_from_date}','#{valid_till_date}','Test State','100.00', '1','50', '2', 'test@test.com','2015-01-01','City','100')"
      elsif operation == "delete"
        query="delete from #{db_name}.#{table_name} where NAME='Test City'"
      end
    end
  end
  if table_name == "FILLER_CAPTIONS" && db_name == "AMAGI_REPORTS_DB"
    if operation == "add" && property == "row"
      query="INSERT INTO #{db_name}.#{table_name}(CHANNEL_ID,CITY_ID,AD_NAME,DURATION) VALUES ('ZC','TEST','TESTAD','50')"  
    elsif operation == "update" && property == "row"
      query="UPDATE #{db_name}.#{table_name} SET CHANNEL_ID='TEST' WHERE CHANNEL_ID='ZC'"
    elsif operation == "delete" && property == "row"
      query="DELETE FROM #{db_name}.#{table_name} WHERE AD_NAME='TESTAD'"
    end
  end
  if table_name == "CHANNELS" && db_name == "MSO_DB"
    if property == "CHANNEL"
      if operation == "add"
        query="INSERT INTO #{db_name}.#{table_name}(NAME, CODE, VALID_FROM, VALID_TO) VALUES ('TEST CHANNEL', 'TEST', '#{valid_from_date}', '#{valid_till_date}')"
      elsif operation == "delete"
        query="DELETE FROM #{db_name}.#{table_name} WHERE NAME='TEST CHANNEL'"
      end
    end
  end
  puts "Doing #{operation} operation on #{table_name} by executing the following query:"
  puts "Executing #{query}"
  ActiveRecord::Base.connection.execute(query)
end

When(/^I use "([^"]*)" database and query "([^"]*)" table and "([^"]*)" new invalid "([^"]*)"$/) do |db_name, table_name, operation, property|
  valid_till=Time.now - 10.day
  valid_from=Time.now - 100.day
  valid_till_date=valid_till.strftime("%Y-%m-%d")
  valid_from_date=valid_from.strftime("%Y-%m-%d")
   if table_name == "CITIES" 
    if property == "CITY"
      if operation == "add"
        query="INSERT INTO #{db_name}.#{table_name}(NAME, CODE, POPULATION,C_AND_S_COVERAGE,VALID_FROM,VALID_TO,STATE,DIGITAL_PENETRATION,STATUS,STB,CITY_TYPE,APPROVED_BY,APPROVED_ON,TYPE,REGION_ID) VALUES('Test City','TST','10000','100.00','#{valid_from_date}','#{valid_till_date}','Test State','100.00', '1','50', '2', 'test@test.com','2015-01-01','City','100')"
      elsif operation == "delete"
        query="DELETE FROM #{db_name}.CITIES WHERE NAME='Test City'"
      end
    end
  end

  if table_name == "CHANNELS" && db_name == "MSO_DB"
    if property == "CHANNEL"
      if operation == "add"
        query="INSERT INTO #{db_name}.#{table_name}(NAME, CODE, VALID_FROM, VALID_TO) VALUES ('TEST CHANNEL', 'TEST', '#{valid_from_date}', '#{valid_till_date}')"
      elsif operation == "delete"
        query="DELETE FROM #{db_name}.#{table_name} WHERE NAME='TEST CHANNEL'"
      end
    end
  end
  
  puts "Doing #{operation} operation on #{table_name} by executing the following query:"
  puts "Executing #{query}"
  ActiveRecord::Base.connection.execute(query)
end


Then(/^the response for GET "([^"]*)" should not have status "([^"]*)"$/) do |url,status|
  puts "Checking response from GET #{url}"
  res=Net::HTTP.get_response(URI(url))
  puts "Response from GET #{url} has status #{res.code} and it should match #{status}"
  Test::Unit::Assertions.assert_no_match(res.code,status)
end

When(/^I request GET for "([^"]*)" URL for "([^"]*)" date for "([^"]*)"$/) do |api, day, channel|
  if day == "current"
    time="?date="+Time.now.strftime("%Y-%m-%d")
  elsif day == "no"
    time=""
  elsif day == "past"
    time=(Time.now - 3.day).strftime("%Y-%m-%d")
    time="?date="+time
  end
  
  if api == "CITIES"
    api_url="http://localhost:3000/api/v1/channels/#{channel}/cities.json"
  elsif api == "FILLER_CAPTIONS"
    api_url="http://localhost:3000/api/v1/channels/#{channel}/filler_captions.json"
  elsif api == "LOCAL_CAPTIONS"
    api_url="http://localhost:3000/api/v1/channels/#{channel}/local_captions.json"
  elsif api == "CHANNELS"
    api_url="http://localhost:3000/api/v1/channels.json"
  elsif api == "SIGNATURE_CAPTIONS"
    api_url="http://localhost:3000/api/v1/channels/#{channel}/signature_captions.json"
  elsif api == "AVAILABLE_MASTERS"
    api_url="http://localhost:3000/api/v1/channels/#{channel}/available_masters.json"
  elsif api == "PLANNED_LOCALS"
    api_url="http://localhost:3000/api/v1/channels/#{channel}/planned_locals.json"
  end
  url=api_url+time
  puts "Checking response for NOVA API #{api} : #{url}"
  @response = HTTParty.get(url)
end

Then(/^the response for GET for "([^"]*)" URL for "([^"]*)" date should have status "([^"]*)"$/) do |api, day, status|
  if day == "current"
    time="?date="+Time.now.strftime("%Y-%m-%d")
  elsif day == "no"
    time=""
  end

  if api == "CHANNELS"
    api_url="http://localhost:3000/api/v1/channels.json"
  end
  url=api_url+time
  res=Net::HTTP.get_response(URI(url))
  puts "Response from GET #{url} has status #{res.code} and it should match #{status}"
  Test::Unit::Assertions.assert_equal(res.code,status)
end

Then(/^output of "([^"]*)" table and url for "([^"]*)" date for "([^"]*)" should match$/) do |api, day, channel|
  time=Time.now.strftime("%Y-%m-%d")
  if day == "no"
    time_url=""
  else
    time_url="?date="+time
  end

  if api == "CITIES"
    api_url="http://localhost:3000/api/v1/channels/#{channel}/cities.json"
    query=""
  elsif api == "CHANNELS"
    api_url="http://localhost:3000/api/v1/channels.json"
  elsif api == "FILLER_CAPTIONS"
    api_url="http://localhost:3000/api/v1/channels/#{channel}/filler_captions.json"
  end

  url=api_url+time_url
  puts "Checking JSON response from #{api} API : #{url}"
  @response = HTTParty.get(url)
  # Convert JSON URL to CSV file '/var/tmp/jsontocsv.csv'
  body=JSON.parse(@response.body)
  json_array=body.to_a
  outputs=json_array[1]
  outputs_list=outputs[1]

  File.open("/var/tmp/jsonop.json","w") do |f|
    f.write(outputs_list.to_json)
  end

  puts "Saving JSON response to /var/tmp/jsontocsv.csv"
  CSV.open("/var/tmp/jsontocsv.csv","w") do |csv|
    JSON.parse(File.open("/var/tmp/jsonop.json").read).each do |hash|
      csv << hash.values
    end
  end

  # Save DB query to CSV file '/var/tmp/dbtocsv.csv'

  if api == "CITIES"
    query="SELECT CODE,NAME FROM MSO_DB.CITIES WHERE (valid_to is null or valid_to >= '#{time}') ORDER BY NAME ASC"
  elsif api == "FILLER_CAPTIONS"
    if day == "no"
      query="SELECT CHANNEL_ID,CITY_ID,AD_NAME,DURATION FROM AMAGI_REPORTS_DB.FILLER_CAPTIONS WHERE (CHANNEL_ID = '#{channel}')";
    else
      query="SELECT CHANNEL_ID,CITY_ID,AD_NAME,DURATION FROM AMAGI_REPORTS_DB.FILLER_CAPTIONS WHERE (CHANNEL_ID = '#{channel}' and VALID_TILL is null or VALID_TILL >= '#{time}')"
    end
  elsif api == "CHANNELS"
    query="SELECT CODE,NAME FROM MSO_DB.CHANNELS WHERE (valid_to is null or valid_to >= '#{time}') ORDER BY NAME ASC"
  end
  puts "Executing #{query} to compare results with #{api} API response"
  puts "Saving response to file /var/tmp/dbtocsv.csv"
  res=ActiveRecord::Base.connection.execute(query)
  CSV.open("/var/tmp/dbtocsv.csv", "w") do |csv|
    res.each do |output|
      csv << output
    end
  end

  # Diff of both these files
  puts "Comparing outputs from both the files.."
  comparefile=FileUtils.identical?('/var/tmp/jsontocsv.csv','/var/tmp/dbtocsv.csv')
  Test::Unit::Assertions.assert_equal comparefile, true
  files = ["/var/tmp/jsontocsv.csv", "/var/tmp/dbtocsv.csv", "/var/tmp/jsonop.json"]
  puts "Doing cleanup of output files"
  files.each do |file|
    puts "Cleaning up #{file} file"
    FileUtils.rm(file)
  end
end

When(/^I request GET for "([^"]*)" URL for "([^"]*)" date with invalid "([^"]*)"$/) do |api, day, property|

  if day == "current"
    time=Time.now.strftime("%Y-%m-%d")
  end
  
  if api == "CITIES" && property  == "channel"
    api_url="http://localhost:3000/api/v1/channels/TSTING/cities.json?date="
    url=api_url+time
  end
  puts "Checking JSON response from URL #{url} for #{api} API"
  @response = HTTParty.get(url)
end

Then(/^the response for GET for "([^"]*)" URL for "([^"]*)" date and invalid "([^"]*)" and should not have status "([^"]*)"$/) do |api, day, property, status|
  if day == "current"
    time=Time.now.strftime("%Y-%m-%d")
  end
  
  if api == "CITIES" && property  == "channel"
    api_url="http://localhost:3000/api/v1/channels/TST/cities.json?date="
    url=api_url+time
  end
  puts "Saving JSON response from URL #{url} for #{api} API and checking status code"
  res=Net::HTTP.get_response(URI(url))
  Test::Unit::Assertions.assert_not_equal res.code, status.to_i
  
end

When(/^I request GET for "([^"]*)" URL for "([^"]*)"$/) do |api, channel|
  if api == "CITIES"
    url="http://localhost:3000/api/v1/channels/#{channel}/cities.json?date="
  end
  puts "Checking JSON response from URL #{url} for #{api} API"
  @response = HTTParty.get(url)
end

Then(/^the response for GET for "([^"]*)" URL for "([^"]*)" date for "([^"]*)" should not have status "([^"]*)"$/) do |api, time, channel, status|
  if time == "no"
    if api == "CITIES"
      url="http://localhost:3000/api/v1/channels/#{channel}/cities.json?date="
    elsif api == "LOCAL_CAPTIONS"
      url="http://localhost:3000/api/v1/channels/#{channel}/local_captions.json?date="
    end
  end
  res=Net::HTTP.get_response(URI(url))
  puts "Response from GET #{url} has status #{res.code} and it should not match #{status}"
  Test::Unit::Assertions.assert_not_equal res.code, status.to_i
end

When(/^I use "([^"]*)" database and query "([^"]*)" table and "([^"]*)" a "([^"]*)"$/) do |db_name, table_name, operation, property|
  if table_name == "FILLER_CAPTIONS"
    if operation == "add" && property == "row"
      query="INSERT INTO #{db_name}.#{table_name}(CHANNEL_ID,CITY_ID,AD_NAME,DURATION) VALUES ('ZN','TEST','TESTAD','50');"  
    elsif operation == "update" && property == "row"
      query="UPDATE #{db_name}.#{table_name} SET CHANNEL_ID='TST' WHERE CHANNEL_ID='ZT'"
    end
  end
  puts "Executing #{operation} operartion for #{table_name} by executing query #{query}"
  ans=ActiveRecord::Base.connection.execute(query)
end

When(/^I use "([^"]*)" database and query "([^"]*)" table and "([^"]*)" a "([^"]*)" for "([^"]*)"$/) do |db_name, table_name, operation, property, channel|
  if operation.include? "past"
    time=(Time.now-3.day).strftime("%Y-%m-%d")
  elsif operation.include? "future"
    time=(Time.now+3.day).strftime("%Y-%m-%d")
  else
    time=Time.now.strftime("%Y-%m-%d")
  end
  if table_name == "SIGNATURE_CAPTIONS"
    api_url="http://localhost:3000/api/v1/channels/#{channel}/signature_captions.json"
  elsif table_name == "AVAILABLE_MASTERS"
    api_url="http://localhost:3000/api/v1/channels/#{channel}/available_masters.json"
  elsif table_name == "ATS_CAMPAIGNS" || table_name == "LOCAL_CAPTIONS"
    api_url="http://localhost:3000/api/v1/channels/#{channel}/local_captions.json"
  end
  time_url="?date="+time
  url=api_url+time_url
  puts url
  response = HTTParty.get(url)
  puts response
  if operation != "add"
    if table_name == "LOCAL_CAPTIONS" || table_name == "ATS_CAMPAIGNS" || table_name == "ATS_CAPTIONS"
      response=response["captions"]
      @campaign_id=response[0]["campaign_id"]
      @caption_id_to_update=response[0]["id"]
    else
      response=response["masters"]
      puts response
      @sign=response[0]["signature"]
      puts @sign
    end
  end
  if operation == "delete" 
    if property == "signature"
      query="delete from AMAGI_REPORTS_DB.RO_SPOT_DETAILS where SCH_DATE='#{time}'  and SIGNATURE='#{@sign}';"
      puts "Deleting query is #{query}"
      query_response=ActiveRecord::Base.connection.execute(query)
    elsif property == "caption"
      query="delete from AMAGI_REPORTS_DB.ATS_CAPTIONS where CAPTION_ID='#{@caption_id_to_update}'"
      puts "Deleting query is #{query}"
      query_response=ActiveRecord::Base.connection.execute(query)
      query="delete from AMAGI_REPORTS_DB.ATS_CAMPAIGNS where CAMPAIGN_ID='#{@campaign_id}'"
      puts "Deleting query is #{query}"
      query_response=ActiveRecord::Base.connection.execute(query)
      query="delete from AMAGI_REPORTS_DB.ATS_CAPTION_RATES where CAPTION_ID='#{@caption_id_to_update}' and channel_code='#{channel}';"
      puts "Deleting query is #{query}"
      query_response=ActiveRecord::Base.connection.execute(query)
    end
  elsif operation.include? "update"
    if property == "signature"
      query_spot="update AMAGI_REPORTS_DB.RO_SPOT_DETAILS set SIGNATURE='TEST_SIGNATURE' where SCH_DATE='#{time}'  and SIGNATURE='#{@sign}';"
      puts "Executing query #{query_spot}"
      query_response=ActiveRecord::Base.connection.execute(query_spot)
      puts "Executing next query"
      query_sign_cap="update AMAGI_REPORTS_DB.RO_SIGNATURE_CAPTIONS set SIGNATURE='TEST_SIGNATURE' where  SIGNATURE='#{@sign}';"
      puts "Executing query #{query_sign_cap}"
      ActiveRecord::Base.connection.execute(query_sign_cap)  
    elsif property == "spot count"
      daypart=response[0]["day_part"]
      if daypart == "Rest of Day"
        daypart="Day"
      end
      spot_count_query="select  sd.spot_count spot_count from AMAGI_REPORTS_DB.RO_CAMPAIGN_DETAILS cd inner join AMAGI_REPORTS_DB.RO_SPOT_DETAILS sd on cd.id = sd.RO_CAMPAIGN_DETAILS_ID where cd.channel_code = '#{channel}' and sd.sch_date = '#{time}'   and sd.signature='#{@sign}' and sd.day_part_name='#{daypart}';"
      puts "Executing spot_count_query: #{spot_count_query}"
      spot_count=ActiveRecord::Base.connection.exec_query(spot_count_query)
      spot_count=spot_count[0]["spot_count"]+10
      query="update AMAGI_REPORTS_DB.RO_SPOT_DETAILS set SPOT_COUNT='#{spot_count}' where SCH_DATE='#{time}' and SIGNATURE='#{@sign}' and DAY_PART_NAME='#{daypart}';"
      puts "Executing query #{query}"
      ActiveRecord::Base.connection.execute(query)
    elsif property == "caption"
      valid_till=(Time.now-200.day).strftime("%Y-%m-%d")
      query="update AMAGI_REPORTS_DB.ATS_CAMPAIGNS set VALID_TILL='#{valid_till}' where campaign_id='#{@campaign_id}'"
      puts "Executing query #{query}"
      ActiveRecord::Base.connection.execute(query)
    elsif property == "caption rate"
      query="update AMAGI_REPORTS_DB.ATS_CAPTION_RATES set rate='1234.56' where caption_id='#{@caption_id_to_update}'"
      puts "Executing query #{query}"
      ActiveRecord::Base.connection.execute(query)
    elsif property == "city"
      query="update AMAGI_REPORTS_DB.ATS_CAPTION_RATES set city_code='TST' where caption_id='#{@caption_id_to_update}'"
      puts "Executing query #{query}"
      ActiveRecord::Base.connection.execute(query)
      query="update AMAGI_REPORTS_DB.ATS_CAMPAIGNS set city_code='TST' where campaign_id='#{@campaign_id}'"
      puts "Executign query #{query}"
      ActiveRecord::Base.connection.execute(query)
    end
  elsif operation == "add" && property == "signature"
    require './data/inserting_spots.rb'
  end
end

Then(/^the response should reflect changes in "([^"]*)" for "([^"]*)" and channel "([^"]*)"$/) do |operation, api, channel|
  if api == "LOCAL_CAPTIONS"
    time=Time.now.strftime("%Y-%m-%d")
    url="http://localhost:3000/api/v1/channels/#{channel}/local_captions.json?date="+time
    response = HTTParty.get(url)
    b=JSON.parse(response.body)
    response=response["captions"][0]
    if operation == "caption update" || operation == "caption delete" 
      puts "Finding caption ID #{@caption_id_to_update} in response"
      ans=b['captions'].detect { |e| e['id'] == "#{@caption_id_to_update}" }
      puts "#{ans}"
      Test::Unit::Assertions.assert_nil (ans)
    elsif operation == "caption rates update"
      puts "Finding caption rates"
      val=response["rates"].values
      flag=1
      val.each do |rate|
        if rate == 1234.56
          puts "Rates update matched!!"
          flag=0
        else
          puts "Rates update did not match"
          puts "Rate is #{rate} while it should have been 1234.56"
          flag=1
        end
      end
      Test::Unit::Assertions.assert_equal(flag,0)
    elsif operation == "city update"
      puts "Finding city_code for caption ID #{@caption_id_to_update} in response"
      flag=1
      puts response["city"]
      if response["city"] == "TST"
        puts "City code matched!!"
        flag=0
      else
        puts "City code not matched!!"
        flag=1
      end
      Test::Unit::Assertions.assert_equal(flag,0)
    end
  end
end

#Only for local_captions
Then(/^the response for GET "([^"]*)" URL for "([^"]*)" date for "([^"]*)" should match response from tables "([^"]*)"$/) do |api, day, channel, tables|
  if day == "current"
    time=Time.now.strftime("%Y-%m-%d")
    time_url="?date="+time
  elsif day == "no"
    time_url=""
  elsif day == "past"
    time=(Time.now - 3.day).strftime("%Y-%m-%d")
    time_url="?date="+time
  elsif day == "future"
    time=(Time.now + 3.day).strftime("%Y-%m-%d")
    time_url="?date="+time
  end 
  flag=1
  if api == "SIGNATURE_CAPTIONS"
    api_url="http://localhost:3000/api/v1/channels/#{channel}/signature_captions.json"
    query_filename="SELECT DISTINCT rcd.FILE_NAME FROM AMAGI_REPORTS_DB.RO_CAMPAIGN_DETAILS rcd WHERE rcd.ID IN (SELECT rsd.RO_CAMPAIGN_DETAILS_ID FROM AMAGI_REPORTS_DB.RO_SPOT_DETAILS rsd WHERE (rsd.SCH_DATE = '#{time}')) AND rcd.CHANNEL_CODE='#{channel}';"
    puts query_filename
    query_exec=ActiveRecord::Base.connection.execute(query_filename)
    file_arr=query_exec.to_a
    file_arr=file_arr[0]
    filename=file_arr[0]
    puts filename
    #query="select rsd.signature, rsd.spot_duration, rsc.CAPTION_ID from AMAGI_REPORTS_DB.RO_SPOT_DETAILS rsd inner join AMAGI_REPORTS_DB.RO_CAMPAIGN_DETAILS rcd inner join AMAGI_REPORTS_DB.RO_SIGNATURE_CAPTIONS rsc where rsd.RO_CAMPAIGN_DETAILS_ID = rcd.ID and rcd.channel_code='#{channel}' and rsd.sch_date='#{time}' and rsc.signature=rsd.signature"
    query="SELECT rsd.SIGNATURE, rsc.CAPTION_ID, rsd.SPOT_DURATION FROM AMAGI_REPORTS_DB.RO_SPOT_DETAILS rsd  inner join AMAGI_REPORTS_DB.RO_SIGNATURE_CAPTIONS rsc on rsc.SIGNATURE = rsd.SIGNATURE  WHERE (rsd.SCH_DATE = '#{time}') and rsc.FILE_NAME = '#{filename}' group by rsc.CAPTION_ID, rsd.SIGNATURE, rsd.SPOT_DURATION order by rsd.SIGNATURE;"
    puts "Executing query: #{query}"
  
    url=api_url+time_url
    puts "Checking JSON response from #{url}"
    response = HTTParty.get(url)
    ans=response["masters"]
    query_response=ActiveRecord::Base.connection.exec_query(query)
    resp=query_response.to_a
    puts "Comparing response from #{query} and #{url} for #{api} API.."
    ans.each do |op|
      flag=1
      sign=op["signature"]
      captions=op["captions"]
      puts sign
      puts captions
      if captions.empty? 
        next
      else
        captions.each do |cap|
          puts "Finding caption #{cap} and signature #{sign}"
          flag=1
          resp.each do |r|
            puts r
            r_sign=r["SIGNATURE"]
            puts "Printing #{r_sign} from response and checking if it matches #{sign}" 
            if r_sign == sign
              puts "Signature #{sign} matches"
              puts "Checking if caption matches now"
              r_cap=r["CAPTION_ID"]
              puts "Finding caption #{r_cap}"
              if r_cap == cap
                puts "Caption #{cap} matches"
                flag=0
                break
              end
            end
          end
        end        
      end
      
      puts "Comparing spot duration for the signature #{sign} now"
      query_duration=" SELECT distinct spot_duration as duration FROM AMAGI_REPORTS_DB.RO_SPOT_DETAILS where SCH_DATE='#{time}' and SIGNATURE='#{sign}'"
      query_duration_response=ActiveRecord::Base.connection.exec_query(query_duration)
      spot_duration=query_duration_response[0]["duration"]
      duration=op["duration"]
      puts "Checking if spot duration: #{duration} from API response matches spot duration: #{spot_duration} from database"
      if duration == spot_duration
        puts "Spot duration matches"
      else
        puts "Spot duration does not match"
        flag=1
      end
    end
  elsif api == "AVAILABLE_MASTERS"
    api_url="http://localhost:3000/api/v1/channels/#{channel}/available_masters.json"
    api_url="http://localhost:3000/api/v1/channels/#{channel}/available_masters.json"
    url=api_url+time_url
    #url="http://localhost:3000/api/v1/channels/#{channel}/available_masters.json?date=2016-01-07"
    puts "Checking JSON response from #{url}"
    response = HTTParty.get(url)
    query_signature="select distinct ept.signature signature_id from AMAGI_REPORTS_DB.EXPECTED_PLAYED_TIMES ept inner join AMAGI_REPORTS_DB.WINDOWS w  on ept.start_time >= w.win_begin  and ept.start_time <= w.win_end  and ept.channel_code = w.channel_code  and w.win_dow = dayofweek(ept.sch_date)  and w.valid_till is null where   ept.sch_date = '#{time}'  and ept.channel_code= '#{channel}';"
    
    puts "Executing query: #{query_signature} to find all signatures"
    signatures=ActiveRecord::Base.connection.exec_query(query_signature)
    signatures.each do |sign|
      sign=sign["signature_id"]
      puts "For signature #{sign}"   
      query="select distinct  sd.day_part_name day_part_name from AMAGI_REPORTS_DB.RO_CAMPAIGN_DETAILS cd inner join AMAGI_REPORTS_DB.RO_SPOT_DETAILS sd on cd.id = sd.RO_CAMPAIGN_DETAILS_ID where cd.channel_code = '#{channel}' and sd.sch_date = '#{time}'   and sd.signature='#{sign}';"
      
      puts "Finding dayparts for #{sign}"
      dayparts=ActiveRecord::Base.connection.exec_query(query)
      puts "Query #{query} executed"
      #puts "Dayparts for #{sign} are #{dayparts}"
      dayparts.each do |daypart|
        daypart=daypart["day_part_name"]
        puts "***********************************"
        puts "For #{sign} and daypart #{daypart}"
        puts "***********************************"
        spot_count_query=" select  sd.spot_count spot_count from AMAGI_REPORTS_DB.RO_CAMPAIGN_DETAILS cd inner join AMAGI_REPORTS_DB.RO_SPOT_DETAILS sd on cd.id = sd.RO_CAMPAIGN_DETAILS_ID where cd.channel_code = '#{channel}' and sd.sch_date = '#{time}'   and sd.signature='#{sign}' and sd.day_part_name='#{daypart}';"
        
        puts "Executing #{spot_count_query}"
        spot_count=ActiveRecord::Base.connection.exec_query(spot_count_query)
        spot_count=spot_count[0]["spot_count"]
        puts "Spot count for #{sign} and #{daypart} is #{spot_count} from table"
        if daypart == "Day"
          use_daypart="Rest of Day"
        else
          use_daypart=daypart
        end

        query_ept="select date_format(ept.start_time, '%H:%i:%S') playout_time from   AMAGI_REPORTS_DB.EXPECTED_PLAYED_TIMES ept inner join AMAGI_REPORTS_DB.WINDOWS w  on ept.start_time >= w.win_begin  and ept.start_time <= w.win_end  and ept.channel_code = w.channel_code  and w.win_dow = dayofweek(ept.sch_date)  and w.valid_till is null where   ept.sch_date = '#{time}'  and ept.channel_code= '#{channel}' and ept.signature='#{sign}' and w.win_label='#{use_daypart}';"
        full_spot_count=0
        empty_spot_count=0
        puts "Executing #{query_ept}"
        ept_hash=ActiveRecord::Base.connection.exec_query(query_ept)
        ept_hash.each do |pt|
          playout_time=pt["playout_time"]
          puts "Playout time is #{playout_time}"
          puts "Doing comparison now"
          response["masters"].each do |line|
            puts line
            puts "JSON response #{line["signature"]} and #{line["day_part"]}"
            puts "@@@@@@@@@@@@@@@@@@@THIS IS A WORKAROUND!!@@@@@@@@@@@@@@@@@@@@"

            if line["day_part"] == "Rest of Day"
              line_daypart="Day"
            else
              line_daypart=line["day_part"]
            end

            puts "From table #{sign} and #{daypart}"
            if line["signature"] == sign && line_daypart == daypart
              puts "Checking playout time"
              puts line["playout_time"]
              if line["playout_time"] == playout_time
                puts "Playout time match"
                full_spot_count=full_spot_count+1
                puts "Printing full_spot_count #{full_spot_count}"
              elsif line["playout_time"] == ""
                puts "Printing empty_spot_count #{empty_spot_count}"
                empty_spot_count=empty_spot_count+1
              end
            end
          end
        end
        sc=empty_spot_count+full_spot_count
        puts "Total count"
        puts "Spot count from output is #{sc} while spot count from table is #{spot_count}"
        if sc != spot_count
          puts "No match"
          flag=1
          break 2
        else
          puts "Match"
          flag=0
        end
      end
    end
  elsif api == "PLANNED_LOCALS"
    api_url="http://localhost:3000/api/v1/channels/#{channel}/planned_locals.json"
    url=api_url+time_url
    puts "Checking JSON response from #{url}"
    response = HTTParty.get(url)
  elsif api == "LOCAL_CAPTIONS"
    query="select  cap.caption_id,  cap.campaign_id,  cap.caption_name,  cap.ad_name,  cap.spot_duration duration,  cap.schedule_type, cr.day_part,  cr.rate,  cmp.city_code,  cmp.brand_name,  ac.name client_name from  AMAGI_REPORTS_DB.ATS_CAPTIONS cap   inner join AMAGI_REPORTS_DB.ATS_CAMPAIGNS cmp  on cap.campaign_id = cmp.campaign_id  inner join AMAGI_REPORTS_DB.ATS_CAPTION_RATES cr  on cap.caption_id = cr.caption_id  left outer join AMAGI_REPORTS_DB.ATS_DEALS ad  on cmp.deal_id = ad.deal_id  left outer join AMAGI_REPORTS_DB.ATS_CLIENTS ac  on ad.client_id = ac.id where  cmp.valid_till >= date_sub(str_to_date('#{time}', '%Y-%m-%d'), interval 60 day)  and cr.channel_code = '#{channel}';"
    puts "Executing #{query}"
    response=ActiveRecord::Base.connection.exec_query(query)
    puts query
    puts "Its response is #{response}"
    api_url="http://localhost:3000/api/v1/channels/#{channel}/local_captions.json"
    url=api_url+time_url
    api_response=HTTParty.get(url)
    api_response=JSON.parse(api_response.body)["captions"]
    count=0
    length_total=response.to_a.length
    response.each do |entry|
      match=0
      puts "======================================================================="
      puts "Checking for entry from database response:"
      puts "Database output is: #{entry}"
      puts "======================================================================="
      api_response.each do |api_output|
        dayparts_from_api=api_output["rates"].keys
        l=api_output["rates"].length
        dayparts_from_api.each do |daypart|
          puts "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
          puts "Checking for entry from API response:"
          puts "API output is #{api_output}"
          puts "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
          caption_id=api_output["id"]
          if entry["caption_id"] != api_output["id"]
            puts "Caption ID does not match"
            puts api_output["id"]
            puts entry["caption_id"]
            break
          else
            puts "Caption ID matches"
    
            if entry["campaign_id"] == api_output["campaign_id"]
              puts "Campaign ID matches"
            else
              break
            end
    
            if entry["client_name"] == api_output["client_name"]
              puts "Client name matches"
            else
              break
            end
    
            if entry["caption_name"] == api_output["name"]
              puts "Caption name matches"
            else
              break
            end
    
            if entry["brand_name"] == api_output["brand_name"]
              puts "Brand name matches"
            else
              break
            end
    
            if entry["ad_name"] == api_output["ad_name"]
              puts "Ad name matches"
            else
              break
            end
    
            if entry["duration"] == api_output["duration"]
              puts "Duration matches"
            else
              break
            end
    
            if entry["schedule_type"] == api_output["schedule_type"]
              puts "Schedule type matches"
            else
              break
            end
    
            if entry["day_part"] == daypart
              if entry["rate"].to_i == api_output["rates"]["#{daypart}"].to_i
                puts "Daypart and rate matches"
              else
                break
              end
            else
              l=l-1
              if l > 0
                next
              else
                break
              end
            end
    
            if entry["city_code"] == api_output["city"]
              puts "City code matches"
            else
              break
            end
    
            if entry["city_code"] == "MA"
              puts "Finding committed cities"
              query_commcities="select group_concat(acc.city_code) as cities from  AMAGI_REPORTS_DB.ATS_CAPTIONS cap   inner join AMAGI_REPORTS_DB.ATS_CAMPAIGNS cmp  on cap.campaign_id = cmp.campaign_id  inner join AMAGI_REPORTS_DB.ATS_CAMPAIGN_COMMITTED_CITIES acc  on cmp.campaign_id = acc.campaign_id where  cmp.valid_till >= date_sub(str_to_date('#{time}', '%Y-%m-%d'), interval 30 day)  and cmp.city_code = 'MA' and cap.caption_id='#{caption_id}' group by cap.caption_id;"
              response_comcities=ActiveRecord::Base.connection.exec_query(query_commcities)
              if response_comcities.empty?
                cities=entry["city_code"].split(",")
              else
                cities=response_comcities[0]["cities"].split(",")
                cities=cities.insert(-1,"MA")
              end
            else
              cities=entry["city_code"].split(",")
            end
    
            if cities.sort == api_output["cities"].sort
              puts "Committed cities match"
            else
              break
            end
            puts "All data matches for this caption"
            match=1
            puts "Match is #{match} so going to next database entry"
            count=count+1
            puts count
            break
          end
        end
        if match == 1
          puts "Next DB entry"
          break
        end
      end
    
    end

    puts "No of matches is #{count} while total no of database rows is #{length_total}"
    if count == length_total
      puts "Outputs match"
      flag=0
    else
      puts "outputs do not match"
      flag=1
    end
  end
  Test::Unit::Assertions.assert_equal(flag,0)
end

#### Dayparts API
#
When(/^I request GET for "([^"]*)" URL for next "([^"]*)" for channels "([^"]*)"$/) do |api, day, channels|
  if day == "Sunday"
    date=Date.yesterday.next_week.advance(:days=>6).strftime("%Y-%m-%d")
  elsif day == "Monday"
    date=Date.yesterday.next_week.advance(:days=>0).strftime("%Y-%m-%d")
  end

  date="?date="+date
  channel_list=channels.split(",")
  channel_list.each do |channel| 
    if api == "DAYPARTS"
      api_url="http://localhost:3000/api/v1/channels/#{channel}/dayparts.json"
    end
    url=api_url+date
    puts "Finding JSON response for #{channel} channel and #{api} API from #{url}"
    @response = HTTParty.get(url)
  end
end

Then(/^the response for GET for "([^"]*)" URL for next "([^"]*)" for channels "([^"]*)" should have status "([^"]*)"$/) do |api, day, channels, status|
  if day == "Sunday"
    date=Date.yesterday.next_week.advance(:days=>6).strftime("%Y-%m-%d")
  elsif day == "Monday"
    date=Date.yesterday.next_week.advance(:days=>0).strftime("%Y-%m-%d")
  end

  date="?date="+date
  channel_list=channels.split(",")
  channel_list.each do |channel| 
    if api == "DAYPARTS"
      api_url="http://localhost:3000/api/v1/channels/#{channel}/dayparts.json"
    end
    url=api_url+date
    puts "Saving JSON response for #{channel} channel and #{api} API from #{url}"
    @response = HTTParty.get(url)
    res=Net::HTTP.get_response(URI(url))
    puts "Response from GET #{url} has status #{res.code} and it should match #{status}"
    Test::Unit::Assertions.assert_equal(res.code,status)
  end
end

Then(/^output of "([^"]*)" URL and table for next "([^"]*)" for channels "([^"]*)" should match$/) do |api, day, channels|
  if day == "Sunday"
    time=Date.yesterday.next_week.advance(:days=>6).strftime("%Y-%m-%d")
  elsif day == "Monday"
    time=Date.yesterday.next_week.advance(:days=>0).strftime("%Y-%m-%d")
  end

  date="?date="+time
  channel_list=channels.split(",")
  channel_list.each do |channel| 
    if api == "DAYPARTS"
      api_url="http://localhost:3000/api/v1/channels/#{channel}/dayparts.json"
    end
    url=api_url+date
    puts "Checking JSON response for #{api} API for channel #{channel} from #{url}"
    @response = HTTParty.get(url)
    body=JSON.parse(@response.body)
    json_array=body.to_a
    outputs=json_array[1]
    outputs_list=outputs[1]

    puts "Comparing response from database and URL for #{channel} and #{time}"
    File.open("/var/tmp/jsonop.json","w") do |f|
      f.write(outputs_list.to_json)
    end

    CSV.open("/var/tmp/jsontocsv.csv","w") do |csv|
      JSON.parse(File.open("/var/tmp/jsonop.json").read).each do |hash|
        csv << hash.values
      end
    end  
# Save DB query to CSV file '/var/tmp/dbtocsv.csv'

    if api == "DAYPARTS"
      query="SELECT CHANNEL_CODE, WIN_LABEL, WIN_LABEL, DATE_FORMAT(WIN_BEGIN,'%H:%i:%s'), DATE_FORMAT(WIN_END,'%H:%i:%s') FROM AMAGI_REPORTS_DB.WINDOWS WHERE (CHANNEL_CODE = '#{channel}' and VALID_TILL is NULL and WIN_DOW = dayofweek('#{time}')) ORDER BY `WINDOWS`.WIN_BEGIN ASC;"
    end
    puts "Executing query #{query} to find database response for #{api} API"
    res=ActiveRecord::Base.connection.execute(query)
    CSV.open("/var/tmp/dbtocsv.csv", "w") do |csv|
      res.each do |output|
        csv << output
      end
    end
#
#  # Diff of both these files
    comparefile=FileUtils.identical?('/var/tmp/jsontocsv.csv','/var/tmp/dbtocsv.csv')
    Test::Unit::Assertions.assert_equal comparefile, true
    files = ["/var/tmp/jsontocsv.csv", "/var/tmp/dbtocsv.csv", "/var/tmp/jsonop.json"]
    files.each do |file|
      puts "Cleaning up #{file}"
      FileUtils.rm(file)
    end
  end
end

When(/^I use "([^"]*)" database and query "([^"]*)" table and "([^"]*)" dayparts for "([^"]*)" for next "([^"]*)"$/) do |db_name, table_name, operation, channels, day|
  if day == "Sunday"
    time=Date.yesterday.next_week.advance(:days=>6).strftime("%Y-%m-%d")
    win_dow=Date.yesterday.next_week.advance(:days=>6).wday+1
  elsif day == "Monday"
    time=Date.yesterday.next_week.advance(:days=>0).strftime("%Y-%m-%d")
    win_dow=Date.yesterday.next_week.advance(:days=>0).wday+1
  end

  date="?date="+time
  valid_from=Time.now - 10.day
  valid_from_date=valid_from.strftime("%Y-%m-%d")
  # ZN,ZT,ZC,TN
  @channel_list=channels.split(",")
  @channel_list.each do |channel| 
    if channel == "ZN"
      win_end="11:59:59"
      win_begin="06:00:00"

    elsif channel == "ZT"
      win_end="11:59:59"
      win_begin="09:00:00"

    elsif channel == "ZC"
      if day == "Monday"
        win_end="10:29:59"
        win_begin="06:00:00"
      elsif day == "Sunday"
        win_end="11:29:59"
        win_begin="07:30:00"
      end
    elsif channel == "TN"
      win_end="16:59:59"
      win_begin="06:00:00"
    end

    if channel == "TN"
      win_label="Non Prime"
    else
      win_label="Morning"
    end
    if operation == "insert"
      query="INSERT INTO #{db_name}.WINDOWS (CHANNEL_CODE, WIN_BEGIN, WIN_END, WIN_LABEL, VALID_FROM, WIN_DOW) VALUES ('#{channel}', '#{win_begin}', '#{win_end}', '#{win_label}', '#{valid_from_date}','#{win_dow}');"
    elsif operation == "delete"
      query="DELETE FROM #{db_name}.WINDOWS WHERE CHANNEL_CODE='#{channel}' AND WIN_DOW=dayofweek('#{time}') AND VALID_FROM='#{valid_from_date}'"
    end

    puts "Executing query #{query} to do #{operation} operation for #{channel} channel"
    ActiveRecord::Base.connection.execute(query)
  end
end

#
When(/^I use "([^"]*)" database and query "([^"]*)" table and "([^"]*)" channel code of "([^"]*)"$/) do |db_name, table_name, operation, channel|
  if table_name == "WINDOWS"
    if operation == "update"
      query="UPDATE #{db_name}.#{table_name} SET CHANNEL_CODE='TEST' WHERE CHANNEL_CODE='#{channel}'"
    end
  end 
  puts "Executing #{query} query for #{table_name} table for #{operation} operation and channel #{channel}"
  ActiveRecord::Base.connection.execute(query)
end

Then(/^the response for GET for "([^"]*)" URL for "([^"]*)" date for "([^"]*)" should have status "([^"]*)"$/) do |api, day, channel, status|
  if day == "current"
    time="?date="+Time.now.strftime("%Y-%m-%d")
  elsif day == "no"
    time=""
  elsif day == "past"
    time=(Time.now - 3.day).strftime("%Y-%m-%d")
    time="?date="+time
  elsif day == "future"
    time=(Time.now + 3.day).strftime("%Y-%m-%d")
    time="?date="+time
  end
  
  if api == "DAYPARTS"
    api_url="http://localhost:3000/api/v1/channels/#{channel}/dayparts.json"
  elsif api == "CITIES"
    api_url="http://localhost:3000/api/v1/channels/#{channel}/cities.json"
  elsif api == "FILLER_CAPTIONS"
    api_url="http://localhost:3000/api/v1/channels/#{channel}/filler_captions.json"
  elsif api == "LOCAL_CAPTIONS"
    api_url="http://localhost:3000/api/v1/channels/#{channel}/local_captions.json"
  elsif api == "SIGNATURE_CAPTIONS"
    api_url="http://localhost:3000/api/v1/channels/#{channel}/signature_captions.json"
  elsif api == "AVAILABLE_MASTERS"
    api_url="http://localhost:3000/api/v1/channels/#{channel}/available_masters.json"
  elsif api == "PLANNED_LOCALS"
    api_url="http://localhost:3000/api/v1/channels/#{channel}/planned_locals.json"
  end
  url=api_url+time
  
  @response = HTTParty.get(url) 
  res=Net::HTTP.get_response(URI(url))
  puts "Response from GET #{url} has status #{res.code} and it should match #{status}"
  Test::Unit::Assertions.assert_equal(res.code,status)
end

Then(/^output of "([^"]*)" url for "([^"]*)" date for "([^"]*)" should not have "([^"]*)"$/) do |api, date, channel, value|
  if date == "current"
    time="?date="+Time.now.strftime("%Y-%m-%d")
  elsif date == "no"
    time=""
  end

  if api == "CITIES"
    api_url="http://localhost:3000/api/v1/channels/#{channel}/cities.json"
  elsif api == "CHANNELS"
    api_url="http://localhost:3000/api/v1/channels.json"
  elsif api == "FILLER_CAPTIONS"
    api_url="http://localhost:3000/api/v1/channels/#{channel}/filler_captions.json"
  elsif api == "SIGNATURE_CAPTIONS"
    api_url="http://localhost:3000/api/v1/channels/#{channel}/signature_captions.json"
  end
  
  url=api_url+time
  @response = HTTParty.get(url)
  
  b=JSON.parse(@response.body)
  
  puts "Finding #{value} in response for #{url} URL for #{api} API"
  if api == "CITIES"
    ans=b['cities'].detect { |e| e['name'] == "#{value}" }
  elsif api == "CHANNELS"
    ans=b['channels'].detect { |e| e['code'] == "#{value}" }
  elsif api == "FILLER_CAPTIONS"
    ans=b['filler_captions'].detect { |e| e['ad_name'] == "#{value}" }
  elsif api == "SIGNATURE_CAPTIONS"
    ans=b['masters'].detect { |e| e['signature'] == "#{@sign}" }
  end 
  
  Test::Unit::Assertions.assert_nil (ans)
end

Then(/^output of "([^"]*)" url for "([^"]*)" date for "([^"]*)" should have "([^"]*)"$/) do |api, date, channel, value|
  if date == "current"
    time="?date="+Time.now.strftime("%Y-%m-%d")
  elsif date == "no"
    time=""
  elsif date == "past"
    time="?date="+(Time.now-3.day).strftime("%Y-%m-%d")
  elsif date == "future"
    time="?date="+(Time.now+3.day).strftime("%Y-%m-%d")
  end

  if api == "CITIES"
    api_url="http://localhost:3000/api/v1/channels/#{channel}/cities.json"
  elsif api == "CHANNELS"
    api_url="http://localhost:3000/api/v1/channels.json"
  elsif api == "FILLER_CAPTIONS"
    api_url="http://localhost:3000/api/v1/channels/#{channel}/filler_captions.json"
  elsif api == "SIGNATURE_CAPTIONS"
    api_url="http://localhost:3000/api/v1/channels/#{channel}/signature_captions.json"
  elsif api == "AVAILABLE_MASTERS"
    api_url="http://localhost:3000/api/v1/channels/#{channel}/available_masters.json"
  elsif api == "LOCAL_CAPTIONS"
    api_url="http://localhost:3000/api/v1/channels/#{channel}/local_captions.json"
  end

  url=api_url+time
  puts url
  @response = HTTParty.get(url)

  b=JSON.parse(@response.body)

  if api == "CITIES"
    puts "Finding #{value} in response for #{url} URL for #{api} API"
    if value == "empty"
      puts "Checking if response is empty for #{api} API"
      ans=b['cities'].any?
    else
      ans=b['cities'].detect { |e| e['name'] == "#{value}" }
    end
  elsif api == "CHANNELS"
    puts "Finding #{value} in response for #{url} URL for #{api} API"
    ans=b['channels'].detect { |e| e['code'] == "#{value}" }
  elsif api == "FILLER_CAPTIONS"
    if value == "empty"
      puts "Checking if response is empty for #{api} API"
      ans=b['filler_captions'].any?
    else
      puts "Finding #{value} in response for #{url} URL for #{api} API"
      ans=b['filler_captions'].detect { |e| e['ad_name'] == "#{value}" }
    end
  elsif api == "SIGNATURE_CAPTIONS" || api == "AVAILABLE_MASTERS"
    if value == "empty"
      puts "Checking if response is empty for #{api} API"
      ans=b['masters'].any?
    else
      puts "Finding #{value} in response for #{url} URL for #{api} API"
      ans=b['masters'].detect { |e| e['signature'] == "#{value}" }
    end
  elsif api == "LOCAL_CAPTIONS" 
    puts "Finding #{value} in response for #{url} URL for #{api} API"
    if value == "empty"
      puts "Checking if response is empty for #{api} API"
      ans=b['captions'].any?
    end
  end
  if value == "empty"
    Test::Unit::Assertions.assert_equal(ans,false)
    puts "Response matches and it is empty for #{api} API"
  else
    Test::Unit::Assertions.assert_not_nil (ans)
  end
end

Then(/^output of "([^"]*)" url for "([^"]*)" date for "([^"]*)" should not be empty$/) do |api, day, property|
  time=Time.now.strftime("%Y-%m-%d")
  if day == "no"
    time_url=""
  else
    time_url="?date="+time
  end
  
  if api == "FILLER_CAPTIONS"
    api_url="http://localhost:3000/api/v1/channels/"+property+"/filler_captions.json"
  end
  url=api_url+time_url
  @response = HTTParty.get(url)
  b=JSON.parse(@response.body)
  if api == "FILLER_CAPTIONS"
    puts "Checking if response is empty for #{api} API"
    ans=b['filler_captions'].any?
  end
  Test::Unit::Assertions.assert_equal(ans,true)
end

Then(/^change "([^"]*)" table "([^"]*)" from "([^"]*)" to "([^"]*)"$/) do |table_name, property, old_value, new_value|
  query="update AMAGI_REPORTS_DB.#{table_name} set #{property}='#{new_value}' where #{property}='#{old_value}'"
  puts "Updating for #{table_name} for #{property} and setting it from #{old_value} to #{new_value}.. Executing query #{query}"
  ActiveRecord::Base.connection.execute(query)  
end

When(/^I use "([^"]*)" database and delete all row in "([^"]*)" for "([^"]*)"$/) do |db_name, rows, channel|
  time=Time.now.strftime("%Y-%m-%d")
  query_for_id="select ID from AMAGI_REPORTS_DB.RO_CAMPAIGN_DETAILS where ID in (select RO_CAMPAIGN_DETAILS_ID from AMAGI_REPORTS_DB.RO_SPOT_DETAILS where SCH_DATE='#{time}') and CHANNEL_CODE='#{channel}';"
  puts "Finding IDs by executing query #{query_for_id}"
  ids=ActiveRecord::Base.connection.exec_query(query_for_id)
  
  query_filename="SELECT DISTINCT rcd.FILE_NAME FROM AMAGI_REPORTS_DB.RO_CAMPAIGN_DETAILS rcd WHERE rcd.ID IN (SELECT rsd.RO_CAMPAIGN_DETAILS_ID FROM AMAGI_REPORTS_DB.RO_SPOT_DETAILS rsd WHERE (rsd.SCH_DATE = '#{time}')) AND rcd.CHANNEL_CODE='#{channel}';"
  puts query_filename
  query_exec=ActiveRecord::Base.connection.execute(query_filename)
  file_arr=query_exec.to_a
  file_arr=file_arr[0]
  filename=file_arr[0]
  puts filename

  rows=rows.split(",")
  ids.each do |id|
    id=id["ID"]
    rows.each do |row|
      puts "For #{row} and deleting data for ID #{id}"
      if row == "RO_SPOT_DETAILS"
        query="delete from #{db_name}.#{row} where SCH_DATE='#{time}' and RO_CAMPAIGN_DETAILS_ID='#{id}'" 
      elsif row == "RO_CAMPAIGN_DETAILS"
        query="delete from #{db_name}.#{row} where CHANNEL_CODE='#{channel}' and ID='#{id}'"  
      elsif row == "RO_SIGNATURE_CAPTIONS"
        query="delete from #{db_name}.#{row} where FILE_NAME='#{filename}'"
      end
      puts "Executing query #{query}"
      ActiveRecord::Base.connection.execute(query) 
    end
  end 
end

When(/^I add JSON file "([^"]*)" for "([^"]*)" for "([^"]*)" for "([^"]*)" API$/) do |filename, channel, date, api|
  date=Time.now.strftime("%Y-%m-%d")
  puts "Executing : \"curl --form \"json=@#{filename}\" http://localhost:3000/api/v1/channels/#{channel}/#{api}?date=#{date}\""
  output=`curl --form \"json=@#{filename}\" http://localhost:3000/api/v1/channels/#{channel}/#{api}?date=#{date}`
  puts "Output is #{output}"
  hash_output=JSON.parse(output)
  @result_status=hash_output["status"].to_i
  @result_message=hash_output["result"]
end

Then(/^the status should be "([^"]*)" and result should be "([^"]*)"$/) do |status, message|
  puts "From previous table #{@result_status} and #{@result_message}"
  puts "Compare with #{status} and #{message}"
  flag=0
  status=status.to_i
  puts "Checking status"
  Test::Unit::Assertions.assert_equal(status,@result_status)   
  
  if @result_message.include? "#{message}"
    flag=0
  else
    flag=1
  end
  #if status == 0
  #  puts "status is #{status}"
 #   if @result_status != status || @result_message != message
  #    puts "Status does not match"
 #     flag=1
 #   end
 # else
 #   puts "status is #{status}"
 #   if @result_message != status || @result_message == "success"
 #     puts "No match"
 #     flag =1
 #   end  
#  end
puts "Checking message"
  Test::Unit::Assertions.assert_equal(flag,0)    
end

Then(/^the data from "([^"]*)" should be added for "([^"]*)" API$/) do |filename, api|
  read_json=File.read(File.expand_path "#{filename}")
  hash_output=JSON.parse(read_json)
  hash_key_daypart=hash_output.keys[0]
  hash_output.each_pair do |daypart, ans|
    #hash_output=hash_output.values[0]
  #channel_code=hash_output["channel_code"]
  #masters=hash_output["masters"]
    channel_code=ans["channel_code"]
    masters=ans["masters"]
    start_time=ans["start_time"]
    end_time=ans["end_time"]
    masters.each_pair do |key, value|
      signature=key
      rotates=value["rotates"][0]
      puts "Rotates is #{rotates}"
      cities=rotates["cities"]
      puts "cities is #{cities}"
      cities.each_pair do |city, info|
        puts "For city #{city} and info #{info}"
        data=info["captions"]
      #data=info["captions"].values
        puts "Data for #{city} is #{data}"
        data=data[0]
        client_name=data["client_name"]
        brand_name=data["brand_name"]
        campaign_id=data["campaign_id"]
        ad_name=data["ad_name"]
        name=data["name"]
        duration=data["duration"]
        schedule_type=data["schedule_type"]
        caption_id=data["id"]
        puts "INFO:"
        puts "#{client_name} #{brand_name} #{campaign_id} #{ad_name} #{name} #{duration} #{schedule_type} #{caption_id}"
      
        ## Verification with database
        query="select ID as id from AMAGI_REPORTS_DB.SCH_MATRIX_BREAKS where `CHANNEL_CODE`='#{channel_code}' and `DAY_PART`='#{daypart}' and `SCH_DATE`=curdate() and `SIGNATURE`='#{signature}' and `WIN_BEGIN`='#{start_time}' and  `WIN_END`='#{end_time}'"
        response=ActiveRecord::Base.connection.exec_query(query)
        if response.empty?
          puts "Execution of the following query returned null:"
          puts "QUERY: #{query}"
          break
        else
          sch_matrix_brk_id=response[0]["id"]  
        end
      
        query_local_ads="select * from AMAGI_REPORTS_DB.SCH_MATRIX_LOCAL_ADS where AD_NAME='#{ad_name}' and CAPTION_ID='#{caption_id}' and CAPTION_NAME='#{name}' and CITY_CODE='#{city}' and SCHEDULED_DURATION='#{duration}' and SCH_MATRIX_BRK_ID='#{sch_matrix_brk_id}';"
        response=ActiveRecord::Base.connection.exec_query(query_local_ads)
        if response.empty?
          puts "Execution of the following query returned null:"
          puts "QUERY: #{query}"
          break
        end
      
        query_schedules="select * from AMAGI_REPORTS_DB.SCHEDULES where AD_NAME='#{ad_name}' and CAMPAIGN_NAME='#{name}' and CAPTION_ID='#{caption_id}' and CHANNEL_CODE='#{channel_code}' and CITY_CODE='#{city}' and DAY_PART='#{daypart}' and SCH_DATE=curdate();"
        response=ActiveRecord::Base.connection.exec_query(query_schedules)
        if response.empty?
          puts "Execution of the following query returned null:"
          puts "QUERY: #{query}"
          break
        end
      end
    end
  end
  
end

When(/^I use "([^"]*)" database and query "([^"]*)" table and update "([^"]*)"  to "([^"]*)" for "([^"]*)" for next "([^"]*)"$/) do |db_name, table_name, property, valid_till, channels, day|
  if day == "Sunday"
    time=Date.yesterday.next_week.advance(:days=>6).strftime("%Y-%m-%d")
    win_dow=Date.yesterday.next_week.advance(:days=>6).wday+1
  elsif day == "Monday"
    time=Date.yesterday.next_week.advance(:days=>0).strftime("%Y-%m-%d")
    win_dow=Date.yesterday.next_week.advance(:days=>0).wday+1
  end
  
  if valid_till == "past"
    valid_till_date=Time.now - 10.day
  elsif valid_till == "future"
    valid_till_date=Time.now + 10.day
  end
  
  valid_till_date=valid_till_date.strftime("%Y-%m-%d")
  
  # ZN,ZT,ZC,TN
  @channel_list=channels.split(",")
  @channel_list.each do |channel| 
    query="update AMAGI_REPORTS_DB.WINDOWS set valid_till='#{valid_till_date}' where channel_code='#{channel}';"
    puts query
    ActiveRecord::Base.connection.execute(query)
  end    
end

When(/^output of "([^"]*)" URL and table for next "([^"]*)" for channels "([^"]*)" should have "([^"]*)"$/) do |api, day, channels, value|
  if day == "Sunday"
    time=Date.yesterday.next_week.advance(:days=>6).strftime("%Y-%m-%d")
  elsif day == "Monday"
    time=Date.yesterday.next_week.advance(:days=>0).strftime("%Y-%m-%d")
  end
  date="?date="+time
  channel_list=channels.split(",")
  channel_list.each do |channel| 
    if api == "DAYPARTS"
      api_url="http://localhost:3000/api/v1/channels/#{channel}/dayparts.json"
    end
    url=api_url+date
    puts url
    puts "Checking JSON response for #{api} API for channel #{channel} from #{url}"
    @response = HTTParty.get(url)
    dayparts_response=JSON.parse(@response.body)
    if value == "empty"
      ans=dayparts_response["dayparts"].any?
    end
    
    Test::Unit::Assertions.assert_equal(ans,false)
  end  
end

When(/^output of "([^"]*)" URL and table for next "([^"]*)" for channels "([^"]*)" should not have "([^"]*)"$/) do |api, day, channels, value|
  if day == "Sunday"
    time=Date.yesterday.next_week.advance(:days=>6).strftime("%Y-%m-%d")
  elsif day == "Monday"
    time=Date.yesterday.next_week.advance(:days=>0).strftime("%Y-%m-%d")
  end
  date="?date="+time
  channel_list=channels.split(",")
  channel_list.each do |channel| 
    if api == "DAYPARTS"
      api_url="http://localhost:3000/api/v1/channels/#{channel}/dayparts.json"
    end
    url=api_url+date
    puts "Checking JSON response for #{api} API for channel #{channel} from #{url}"
    @response = HTTParty.get(url)
    dayparts_response=JSON.parse(@response.body)
    if value == "empty"
      ans=dayparts_response["dayparts"].any?
    end
    
    Test::Unit::Assertions.assert_equal(ans,true)
  end  
end


When(/^I use "([^"]*)" database and query "([^"]*)" table and update "([^"]*)" of "([^"]*)" for next "([^"]*)"$/) do |db_name, table_name, property, channels, day|
  if day == "Sunday"
    time=Date.yesterday.next_week.advance(:days=>6).strftime("%Y-%m-%d")
    win_dow=Date.yesterday.next_week.advance(:days=>6).wday+1
  elsif day == "Monday"
    time=Date.yesterday.next_week.advance(:days=>0).strftime("%Y-%m-%d")
    win_dow=Date.yesterday.next_week.advance(:days=>0).wday+1
  end
  channel_list=channels.split(",")
  channel_list.each do |channel| 
    query="select distinct win_label from AMAGI_REPORTS_DB.WINDOWS where channel_code='#{channel}' and win_dow='#{win_dow}';"
    puts query
    response=ActiveRecord::Base.connection.exec_query(query)
    one_daypart=response[0]["win_label"]
    query_win_begin="update AMAGI_REPORTS_DB.WINDOWS set win_begin='00:00:00' where channel_code='#{channel}' and win_dow='#{win_dow}' and WIN_LABEL='#{one_daypart}';"
    ActiveRecord::Base.connection.execute(query_win_begin)
    query_win_end="update AMAGI_REPORTS_DB.WINDOWS set win_end='23:59:59' where channel_code='#{channel}' and win_dow='#{win_dow}' and WIN_LABEL='#{one_daypart}';"
    ActiveRecord::Base.connection.execute(query_win_end)
  end
end


# When(/^I "([^"]*)" local deal using XML file$/) do |action|
#
# _dbcliScript="/usr/amagi/DBCli/databaseupdater.sh"
# status = system("'#{_dbcliScript}' -F deal -a insert '#{file}'")
# assert_equal status, true
# end
#
#
# When(/^I use "([^"]*)" database and query "([^"]*)" table and "([^"]*)" data for "([^"]*)" for "([^"]*)"$/) do |arg1, arg2, arg3, arg4, arg5|
#   pending # Write code here that turns the phrase above into concrete actions
# end
#
# When(/^I use "([^"]*)" database and query "([^"]*)" table and "([^"]*)" all data for "([^"]*)" for "([^"]*)"$/) do |arg1, arg2, arg3, arg4|
#   pending # Write code here that turns the phrase above into concrete actions
# end
#
# When(/^I use "([^"]*)" database and for "([^"]*)" API, change the "([^"]*)" schedule date to "([^"]*)" for "([^"]*)"$/) do |arg1, arg2, arg3, arg4, arg5|
#   pending # Write code here that turns the phrase above into concrete actions
# end
#
# Then(/^the output for "([^"]*)" URL should "([^"]*)" information for new signature$/) do |arg1, arg2|
#   pending # Write code here that turns the phrase above into concrete actions
# end