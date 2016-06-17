#require 'database_cleaner'
require 'active_record'
require 'logger'
require 'factory_girl'

ActiveRecord::Base.establish_connection(
	:adapter => 'mysql2',
	:database => 'AMAGI_REPORTS_DB',
	:password => 'amagi123')
#ActiveRecord::Migrator.migrate("db/migrate")

#class Ats_clients < ActiveRecord::Base
#	quoted_table_name "ATS_CLIENTS"
#end

#class Ats_client_contacts < ActiveRecord::Base
#	quoted_table_name "ATS_CLIENT_CONTACTS"
#end

