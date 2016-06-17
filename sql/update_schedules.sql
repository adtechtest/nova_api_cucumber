update
  SCHEDULES aps inner join WINDOWS w
    on ((aps.win_begin >= w.win_begin and aps.win_begin <= w.win_end) or
        (w.win_begin <= aps.win_begin and w.win_end <= w.win_begin) or
        (aps.win_begin <= w.win_end and w.win_end <= w.win_begin))
    and dayofweek(aps.sch_date) = w.win_dow
    and aps.channel_code = w.channel_code
    and (w.valid_till is null)
set
  aps.day_part = w.win_label
where 
  aps.day_part is null and aps.sch_date >= '2015-06-01'
;

