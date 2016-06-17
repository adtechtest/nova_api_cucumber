select
  cap.caption_id,
  cap.campaign_id,
  cap.caption_name,
  cap.ad_name,
  cap.spot_duration duration,
  cap.schedule_type,
  cap.signature,
  cr.day_part,
  cr.rate,
  cmp.city_code,
  cmp.brand_name,
  ac.name client_name
from
  AMAGI_REPORTS_DB.ATS_CAPTIONS cap 
  inner join AMAGI_REPORTS_DB.ATS_CAMPAIGNS cmp
    on cap.campaign_id = cmp.campaign_id
  inner join AMAGI_REPORTS_DB.ATS_CAPTION_RATES cr
    on cap.caption_id = cr.caption_id
  left outer join AMAGI_REPORTS_DB.ATS_DEALS ad
    on cmp.deal_id = ad.deal_id
  left outer join AMAGI_REPORTS_DB.ATS_CLIENTS ac
    on ad.client_id = ac.id
where
  cmp.valid_till >= date_sub(str_to_date('{date}', '%Y-%m-%d'), interval 60 day)
  and cr.channel_code = '{channel_code}'
;
