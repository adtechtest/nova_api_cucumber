class MsoDb < ActiveRecord::Base
  establish_connection :mso_db
  self.abstract_class = true
end
