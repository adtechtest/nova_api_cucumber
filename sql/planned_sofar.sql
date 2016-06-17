-- planned_sofar.sql
select
  a.day_part,
  a.caption_id,
  a.city_code,
  a.channel_code,
  sum(rotates) as rotates,
  cp.schedule_type
from
  AMAGI_REPORTS_DB.ATS_ROTATE_PLANS a
  inner join AMAGI_REPORTS_DB.ATS_CAPTIONS cp
    on cp.caption_id = a.caption_id
  inner join AMAGI_REPORTS_DB.ATS_CAMPAIGNS cmp
    on cp.campaign_id = cmp.campaign_id
where
  a.channel_code = '{channel_code}'
  and cmp.valid_till >= date_add(str_to_date('{date}', '%Y-%m-%d'), interval -60 day)
  and a.rotate_date >= date_add(str_to_date('{date}', '%Y-%m-%d'), interval -150 day)
  and a.rotate_date < curdate()
group by
  a.city_code,
  a.caption_id,
  a.day_part
order by
  a.city_code,
  a.caption_id,
  a.day_part
