class AtsCampaign < AmagiReportsDb
  self.table_name = "ATS_CAMPAIGNS"
  self.primary_key = "CAMPAIGN_ID"

  has_many :captions, :class_name => "AtsCaption", foreign_key: "CAMPAIGN_ID", dependent: :destroy
  has_many :telecast_cities, :class_name => "AtsTelecastCity", foreign_key: "CAMPAIGN_ID", dependent: :destroy

  belongs_to :deal, :class_name => "AtsDeal", foreign_key: "DEAL_ID"
end
