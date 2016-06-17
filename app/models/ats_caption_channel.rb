class AtsCaptionChannel < AmagiReportsDb
  self.table_name = "ATS_CAPTION_CHANNELS"
  self.primary_key = :CAPTION_ID, :CHANNEL_CODE

  belongs_to :caption, :class_name => "AtsCaption", foreign_key: "CAPTION_ID"
end
