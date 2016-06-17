select
  aps.sch_date,
  ad.deal_id,
  cmp.campaign_id,
  aps.caption_id,
  cap.caption_name,
  cmp.name campaign_name,
  aps.channel_code,
  ch.name channel_name,
  aps.city_code,
  aps.ad_name as creative_id,
  aps.day_part as daypart,
  group_concat(aps.aired_time_t) as aired_times,
  count(*) as spot_count ,
  sum(aps.billed_aired_duration) as total_billed_duration
from
  AMAGI_REPORTS_DB.CON_ASPLAYED_STATUSES aps
  inner join MSO_DB.CITIES ci
    on aps.city_code = ci.code
  inner join MSO_DB.CHANNELS ch
    on aps.channel_code = ch.code
  left outer join AMAGI_REPORTS_DB.ATS_CAPTIONS cap
    on aps.caption_id = cap.caption_id
  left outer join AMAGI_REPORTS_DB.ATS_CAMPAIGNS cmp
    on cap.campaign_id = cmp.campaign_id
  left outer join AMAGI_REPORTS_DB.ATS_DEALS ad
    on cmp.deal_id = ad.deal_id
  left outer join AMAGI_REPORTS_DB.ATS_CLIENTS ac
    on ad.client_id = ac.id
where
  aps.sch_date >= '{start_date}' and
  aps.sch_date <=  '{end_date}' and
  cap.caption_id like '{caption_id}' and
  cmp.campaign_id like '{campaign_id}' and
  ad.deal_id like '{deal_id}' and
  ch.code like '{channel_code}' and
  aps.status = 1 
group by
  sch_date,
  deal_id,
  daypart,
  campaign_id,
  caption_id,
  caption_name,
  campaign_name,
  channel_code,
  channel_name,
  city_code,
  creative_id
order by
  aps.sch_date,
  aps.aired_time_t,
  aps.billed_aired_duration,
  aps.caption_id
;
