select
  cap.caption_id,
  acc.city_code
from
  AMAGI_REPORTS_DB.ATS_CAPTIONS cap 
  inner join AMAGI_REPORTS_DB.ATS_CAMPAIGNS cmp
    on cap.campaign_id = cmp.campaign_id
  inner join AMAGI_REPORTS_DB.ATS_CAMPAIGN_COMMITTED_CITIES acc
    on cmp.campaign_id = acc.campaign_id
where
  cmp.valid_till >= date_sub(str_to_date('{date}', '%Y-%m-%d'), interval 30 day)
  and cmp.city_code = 'MA'
;
