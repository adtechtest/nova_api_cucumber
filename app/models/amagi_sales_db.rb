class AmagiSalesDb < ActiveRecord::Base
  establish_connection "amagi_sales_db"
  self.abstract_class = true
end
