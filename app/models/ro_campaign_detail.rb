class RoCampaignDetail < AmagiReportsDb
  self.table_name = "RO_CAMPAIGN_DETAILS"

  has_many :RoSpotDetail, :foreign_key => "RO_CAMPAIGN_DETAILS_ID"
end
