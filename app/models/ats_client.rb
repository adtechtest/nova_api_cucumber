class AtsClient < AmagiReportsDb
  self.table_name = "ATS_CLIENTS"
  self.primary_key = "ID"

  has_many :deals, :class_name => "AtsDeal", foreign_key: "CLIENT_ID"
end
