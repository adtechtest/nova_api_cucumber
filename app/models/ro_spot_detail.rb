class RoSpotDetail < AmagiReportsDb
  self.table_name = "RO_SPOT_DETAILS"

  belongs_to :RoCampaignDetail, :foreign_key => "RO_CAMPAIGN_DETAILS_ID"
end
