class AtsDeal < AmagiReportsDb
  self.table_name = "ATS_DEALS"
  self.primary_key = "DEAL_ID"

  has_many :campaigns, :class_name => 'AtsCampaign' , foreign_key: "DEAL_ID", dependent: :destroy
  belongs_to :client, :class_name => 'AtsClient', foreign_key: "CLIENT_ID"
  belongs_to :agency, :class_name => 'AtsAgency', foreign_key: "AGENCY_ID"
end
