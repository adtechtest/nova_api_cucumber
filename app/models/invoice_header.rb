class InvoiceHeader < ActiveRecord::Base
  self.table_name = "invoice_header"
  self.primary_key = "client_name"
end
