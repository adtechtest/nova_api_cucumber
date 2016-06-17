class AmagiReportsDb < ActiveRecord::Base
  establish_connection :amagi_reports_db
  self.abstract_class = true
end
