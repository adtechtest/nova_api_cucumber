class AtsTelecastCity < AmagiReportsDb
  self.table_name = "ATS_TELECAST_CITIES"
  self.primary_key = :CAMPAIGN_ID, :CITY_NAME

  belongs_to :campaign, :class_name => "AtsCampaign", foreign_key: "CAMPAIGN_ID"
end
