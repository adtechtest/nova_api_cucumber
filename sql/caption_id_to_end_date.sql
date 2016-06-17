-- caption_id_to_end_date.sql
select 
  caption_id,
  cmp.valid_till end_date
from
  AMAGI_REPORTS_DB.ATS_CAPTIONS cap
  inner join AMAGI_REPORTS_DB.ATS_CAMPAIGNS cmp
    on cap.campaign_id = cmp.campaign_id
where
  cmp.valid_till >= date_add(str_to_date('{date}', '%Y-%m-%d'), interval -60 day)
;
