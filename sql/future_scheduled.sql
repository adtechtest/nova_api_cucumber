-- future_scheduled.sql
select
  sch.day_part,
  sch.caption_id,
  sch.city_code,
  sch.channel_code,
  count(1) rotates
from
  AMAGI_REPORTS_DB.SCHEDULES sch
where
  sch.channel_code = '{channel_code}'
  and sch.sch_date != '{date}'
  and sch.sch_date >= curdate()
  and sch.caption_id != '000000000000'
group by
  sch.day_part,
  sch.channel_code,
  sch.city_code,
  sch.caption_id
