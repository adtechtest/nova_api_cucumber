class AtsCampaignCommittedCity < AmagiReportsDb
  self.table_name = "ATS_CAMPAIGN_COMMITTED_CITIES"
  self.primary_key = :CAMPAIGN_ID, :CITY_CODE

  belongs_to :ats_campaign, foreign_key: "CAMPAIGN_ID"
end
