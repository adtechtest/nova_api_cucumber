class AtsRoRotatePlan < AmagiReportsDb
  self.table_name = "ATS_RO_ROTATE_PLANS"
  self.primary_keys = :CAPTION_ID, :CITY_CODE, :CHANNEL_CODE, :ROTATE_DATE, :DAY_PART

  belongs_to :caption, :class_name => "AtsCaption", foreign_key: "CAPTION_ID"
end
