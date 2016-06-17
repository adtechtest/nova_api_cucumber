select 
  ept.sch_date,
  ept.channel_code,
  w.win_label day_part,
  ept.signature signature_id,
  date_format(ept.start_time, '%H:%i:%S') playout_time
from 
  AMAGI_REPORTS_DB.EXPECTED_PLAYED_TIMES ept inner join AMAGI_REPORTS_DB.WINDOWS w
    on ept.start_time >= w.win_begin
    and ept.start_time <= w.win_end
    and ept.channel_code = w.channel_code
    and w.win_dow = dayofweek(ept.sch_date)
    and w.valid_till is null
where 
  ept.sch_date = '{date}'
  and ept.channel_code= '{channel_code}'
order by 
  start_time
;
