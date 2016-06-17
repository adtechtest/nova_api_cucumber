-- played.sql
select
  a.daypart day_part,
  a.caption_id,
  a.city_code,
  cp.schedule_type,
  sum(played_rotates) as rotates
from
  AMAGI_REPORTS_DB.AD_PLAY_STATUSES a
  inner join AMAGI_REPORTS_DB.ATS_CAPTIONS cp
    on cp.caption_id = a.caption_id
  inner join AMAGI_REPORTS_DB.ATS_CAMPAIGNS cmp
    on cp.campaign_id = cmp.campaign_id
  inner join AMAGI_REPORTS_DB.WINDOWS w
    on w.win_dow = dayofweek(a.date)
    and w.channel_code = a.channel_code
    and w.win_label = a.daypart and w.valid_till is null
where
  a.channel_code = '{channel_code}'
  and cmp.valid_till >= date_add(str_to_date('{date}', '%Y-%m-%d'), interval -60 day)
  and a.date >= date_add(str_to_date('{date}', '%Y-%m-%d'), interval -150 day)
  and a.date <= date_add(str_to_date('{date}', '%Y-%m-%d'), interval -1 day)
  and a.city_code != 'MA'
group by
  a.city_code,
  a.caption_id,
  w.win_label,
  cp.schedule_type
order by
  a.city_code,
  a.caption_id,
  w.win_label,
  cp.schedule_type

