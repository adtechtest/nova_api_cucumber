json.status 0
json.invoice_number @invoice_number
json.total_spots @count
json.spot_details do
  json.array! @asruns do |asrun|
    json.caption_name asrun["CAPTION_NAME"]
    json.channel_code asrun["CHANNEL_CODE"]
    json.duration asrun["BILLED_AIRED_DURATION"]
    json.telecast_date asrun["SCH_DATE"]
    json.telecast_time asrun["AIRED_TIME"]
  end
end
