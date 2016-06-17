-- asrun_pending.sql
select
  sch.day_part,
  sch.caption_id,
  sch.channel_code,
  sch.city_code,
  sum(sch.rotates) rotates
from (
    select
      sch.sch_date,
      sch.day_part,
      sch.caption_id,
      sch.channel_code,
      sch.city_code,
      count(1) rotates
    from
      AMAGI_REPORTS_DB.SCHEDULES sch 
    where
      sch.channel_code = '{channel_code}'
      and sch.sch_date != '{date}'
      and sch.sch_date >= date_add(str_to_date('{date}', '%Y-%m-%d'), interval -150 day)
      and sch.caption_id != '000000000000'
      and sch.sch_date < curdate()
    group by
      sch.sch_date,
      sch.day_part,
      sch.caption_id,
      sch.channel_code,
      sch.city_code
  ) sch left outer join (
    select 
      distinct
      a.channel_code,
      a.city_code,
      a.date sch_date
    from
      AMAGI_REPORTS_DB.AD_PLAY_STATUSES a
    where
      a.channel_code = '{channel_code}'
      and a.date >= date_add(str_to_date('{date}', '%Y-%m-%d'), interval -150 day)
    order by
      a.channel_code,
      a.city_code,
      a.date
  ) aps
    on sch.sch_date = aps.sch_date
    and sch.channel_code = aps.channel_code
    and sch.city_code = aps.city_code
where
  aps.channel_code is null
group by
  sch.day_part,
  sch.caption_id,
  sch.channel_code,
  sch.city_code
;
