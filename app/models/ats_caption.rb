class AtsCaption < AmagiReportsDb
  self.table_name = "ATS_CAPTIONS"
  self.primary_key = "CAPTION_ID"

  belongs_to :campaign, :class_name => "AtsCampaign", foreign_key: "CAMPAIGN_ID"
  has_many :rates, :class_name => "AtsCaptionRate", foreign_key: "CAPTION_ID", dependent: :destroy
  has_many :internal_rates, :class_name => "AtsCaptionInternalRate", foreign_key: "CAPTION_ID", dependent: :destroy
  has_many :channels, :class_name => "AtsCaptionChannel", foreign_key: "CAPTION_ID", dependent: :destroy
  has_many :rotates, :class_name => "AtsRotatePlan", foreign_key: "CAPTION_ID", dependent: :destroy
  has_many :ro_rotates, :class_name => "AtsRoRotatePlan", foreign_key: "CAPTION_ID", dependent: :destroy
end
