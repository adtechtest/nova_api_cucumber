class AtsCommittedCity < AmagiReportsDb
  self.table_name = "ATS_CAMPAIGN_COMMITTED_CITIES"

  belongs_to :ats_campaign, :primary_key => "CAMPAIGN_ID", :foreign_key => "CAMPAIGN_ID"
end
