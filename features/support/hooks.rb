config   = Rails.configuration.database_configuration
#host     = config[Rails.env]["host"]
#database = config[Rails.env]["database"]
username = config[Rails.env]["username"]
password = config[Rails.env]["password"]
sql_dump_dir="/usr/amagi/db_dumps"
#sql_dump_dir="/home/chaynika/work/nova/nova/sql"

After ('@channels') do |tag|
  puts tag
  puts "CLEANUP is IMPORTANT!!"
  puts "Cleaning up the mess you did"
  puts "Retrieving old channels table.."
  puts "Executing: mysql -u #{username} -p#{password} MSO_DB < #{sql_dump_dir}/CHANNELS.sql"
  system("mysql -u #{username} -p#{password} MSO_DB < #{sql_dump_dir}/CHANNELS.sql")
end

After ('@cities') do 
  puts "CLEANUP is IMPORTANT!!"
  puts "Cleaning up the mess you did"
  puts "Retrieving old cities table.."
  puts "Executing: mysql -u #{username} -p#{password} MSO_DB < #{sql_dump_dir}/CITIES.sql"
  system("mysql -u #{username} -p#{password} MSO_DB < #{sql_dump_dir}/CITIES.sql")
end

After ('@windows') do 
  puts "CLEANUP is IMPORTANT!!"
  puts "Cleaning up the mess you did"
  puts "Retrieving old windows table.."
  puts username
  puts password
  puts "Executing: mysql -u #{username} -p#{password} AMAGI_REPORTS_DB < #{sql_dump_dir}/WINDOWS.sql"
  system("mysql -u #{username} -p#{password} AMAGI_REPORTS_DB < #{sql_dump_dir}/WINDOWS.sql")
end

After ('@filler_captions') do
  puts "CLEANUP is IMPORTANT!!"
  puts "Cleaning up the mess you did"
  puts "Retrieving old filler_captions table.."
  system("mysql -u #{username} -p#{password} AMAGI_REPORTS_DB < #{sql_dump_dir}/FILLER_CAPTIONS.sql")
end

After ('@ats_campaigns') do
  puts "CLEANUP is IMPORTANT!!"
  puts "Cleaning up the mess you did"
  table="ATS_CAMPAIGNS"
  puts "Retrieving old #{table} table.."
  system("mysql -u#{username} -p#{password} AMAGI_REPORTS_DB < #{sql_dump_dir}/#{table}.sql")
end

After ('@ats_captions') do
  puts "CLEANUP is IMPORTANT!!"
  puts "Cleaning up the mess you did"
  table="ATS_CAPTIONS"
  puts "Retrieving old #{table} table.."
  system("mysql -u #{username} -p#{password} AMAGI_REPORTS_DB < #{sql_dump_dir}/#{table}.sql")
end

After ('@ats_caption_rates') do
  puts "CLEANUP is IMPORTANT!!"
  puts "Cleaning up the mess you did"
  table="ATS_CAPTION_RATES"
  puts "Retrieving old #{table} table.."
  system("mysql -u #{username} -p#{password} AMAGI_REPORTS_DB < #{sql_dump_dir}/#{table}.sql")
end

After ('@ro_campaign_details') do
  puts "CLEANUP is IMPORTANT!!"
  puts "Cleaning up the mess you did"
  table="RO_CAMPAIGN_DETAILS"
  puts "Retrieving old #{table} table.."
  system("mysql -u #{username} -p#{password} AMAGI_REPORTS_DB < #{sql_dump_dir}/#{table}.sql")
end

After ('@ro_spot_details') do
  puts "CLEANUP is IMPORTANT!!"
  puts "Cleaning up the mess you did"
  table="RO_SPOT_DETAILS"
  puts "Retrieving old #{table} table.."
  system("mysql -u #{username} -p#{password} AMAGI_REPORTS_DB < #{sql_dump_dir}/#{table}.sql")
end

After ('@expected_played_time') do
  puts "CLEANUP is IMPORTANT!!"
  puts "Cleaning up the mess you did"
  table="EXPECTED_PLAYED_TIMES"
  puts "Retrieving old #{table} table.."
  system("mysql -u #{username} -p#{password} AMAGI_REPORTS_DB < #{sql_dump_dir}/#{table}.sql")
end

After ('@ro_signature_captions') do
  puts "CLEANUP is IMPORTANT!!"
  puts "Cleaning up the mess you did"
  table="RO_SIGNATURE_CAPTIONS"
  puts "Retrieving old #{table} table.."
  system("mysql -u #{username} -p#{password} AMAGI_REPORTS_DB < #{sql_dump_dir}/#{table}.sql")
end

After ('@ad_play_statuses') do
  puts "CLEANUP is IMPORTANT!!"
  puts "Cleaning up the mess you did"
  table="AD_PLAY_STATUSES"
  puts "Retrieving old #{table} table.."
  system("mysql -u #{username} -p#{password} AMAGI_REPORTS_DB < #{sql_dump_dir}/#{table}.sql")
end

  
