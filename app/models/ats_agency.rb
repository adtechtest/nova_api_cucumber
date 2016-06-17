class AtsAgency < AmagiReportsDb
  self.table_name = "ATS_AGENCIES"
  self.primary_key = "ID"

  has_many :deals, :class_name => "AtsDeal", foreign_key: "AGENCY_ID"
end
