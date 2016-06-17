-- future_overscheduled.sql
select
  sch.day_part,
  sch.caption_id,
  sch.city_code,
  sch.channel_code,
  if(sum(sch.rotates - ifnull(rp.rotates, 0)) > 0, sum(sch.rotates-ifnull(rp.rotates, 0)), 0) rotates
from (
    select
      sch.sch_date,
      sch.day_part,
      sch.channel_code,
      sch.city_code,
      sch.caption_id,
      count(1) rotates
    from
      AMAGI_REPORTS_DB.SCHEDULES sch
    where
      sch.channel_code = '{channel_code}'
      and sch.sch_date != '{date}'
      and sch.sch_date >= curdate()
      and sch.caption_id != '000000000000'
    group by
      sch.sch_date,
      sch.day_part,
      sch.channel_code,
      sch.city_code,
      sch.caption_id
  ) sch left outer join (
    select 
      a.rotate_date sch_date,
      a.day_part,
      a.channel_code,
      a.city_code,
      a.caption_id,
      sum(rotates) rotates
    from
      AMAGI_REPORTS_DB.ATS_ROTATE_PLANS a
    where
      a.channel_code = '{channel_code}' 
      and a.rotate_date != '{date}'
      and a.rotate_date >= curdate()
    group by
      a.rotate_date,
      a.day_part,
      a.channel_code,
      a.city_code,
      a.caption_id
  ) rp
    on sch.sch_date = rp.sch_date
    and sch.channel_code = rp.channel_code
    and sch.city_code = rp.city_code
    and sch.caption_id = rp.caption_id
    and sch.day_part = rp.day_part
group by
  sch.day_part,
  sch.channel_code,
  sch.caption_id,
  sch.city_code
;
