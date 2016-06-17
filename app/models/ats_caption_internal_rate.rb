class AtsCaptionInternalRate < AmagiReportsDb
  self.table_name = "ATS_CAPTION_INTERNAL_RATES"
  self.primary_keys = :CAPTION_ID, :CITY_CODE, :CHANNEL_CODE, :DAY_PART

  belongs_to :caption, :class_name => "AtsCaption", foreign_key: "CAPTION_ID"
end
