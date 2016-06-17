select
  cap.caption_name CAPTION_NAME,
  aps.CHANNEL_CODE,
  aps.BILLED_AIRED_DURATION,
  aps.SCH_DATE,
  aps.AIRED_TIME 
from 
  AMAGI_REPORTS_DB.INVOICES inv
  left outer join AMAGI_REPORTS_DB.ATS_CAPTIONS cap
    on inv.campaign_id = cap.campaign_id
  inner join AMAGI_REPORTS_DB.CON_ASPLAYED_STATUSES aps
    on cap.caption_id = aps.caption_id
    and inv.channel_code = aps.channel_code
where
  aps.sch_date >= inv.START_DATE
  and aps.sch_date <= inv.END_DATE
  and aps.status = 1
  and inv.invoice_number like '{invoice_number}' 
;
