select
  invd.CLIENT_NAME,
  cl.ADDRESS1 CLIENT_ADDRESS_LINE_1,
  cl.ADDRESS2 CLIENT_ADDRESS_LINE_2,
  concat(cl.city, ' ', cl.state, ' ', cl.pin_code) CLIENT_ADDRESS_LINE_3,
  ag.ADDRESS1 AGENCY_ADDRESS_LINE_1,
  ag.ADDRESS2 AGENCY_ADDRESS_LINE_2,
  concat(ag.city, ' ', ag.state, ' ', ag.pin_code) AGENCY_ADDRESS_LINE_3,
  invd.START_DATE,
  invd.END_DATE,
  invd.SL_NO,
  cmp.name CAMPAIGN,
  invd.TARGET_CITY,
  invd.START_DATE_L,
  invd.END_DATE_L,
  invd.PERIOD,
  invd.CHANNEL,
  invd.SPOT_DURATION,
  invd.TOTAL_SECONDAGES,
  invd.SPOT_COUNT,
  invd.INVOICE_NUMBER,
  invd.INVOICE_DATE,
  invd.REF_NUM,
  invd.GROSS_TOTAL,
  invd.TOTAL_AFTER_SLAB_DIS,
  invd.SLAB_DISCOUNT_PRCT,
  invd.SLAB_DISCOUNT_AMT,
  invd.AGENCY_DISCOUNT_PRCT,
  invd.AGENCY_DICSOUNT_AMT,
  invd.NET_AMT,
  invd.SERVICE_TAX_PRCT,
  invd.SERVICE_TAX_AMT,
  invd.EDUCATION_CESS_TAX_PRCT,
  invd.EDUCATION_CESS_TAX_AMT,
  invd.HigherEducationCessPercentage,
  invd.HIGHER_EDUCATION_CESS_AMT,
  invd.INVOICE_AMT,
  invd.AMT_IN_WORDS,
  invd.STATUS,
  invd.SELECT_APP,
  invd.CAPTION_NAME,
  invd.APPROVAL_STATUS,
  if (ag.id is null, 
   concat(ifnull(ad.client_invoice_email, ''), ' ', ifnull(cl.invoice_mail_id, '')),
   concat(ifnull(ad.agency_invoice_email, ''), ' ', ifnull(ag.invoice_mail_id, ''))
  ) MAILID,
  invd.FILENAME,
  invd.CATEGORY,
  invd.PAYMENT_DUE_DATE,
  invd.CAMPAIGNCITY,
  invd.AGENCY_NAME,
  ad.AMAGI_CONTACT_NAME SALES_MEMBER_NAME,
  ad.AMAGI_CONTACT_EMAIL_ID SALES_MEMBER_MAIL_ID,
  ad.SALES_OFFICE,
  sp2.name TEAM_LEAD_NAME,
  sp.manager_mail_id TEAM_LEAD_MAIL_ID,
  cmp.BRAND_NAME,
  ag.PAN_NUMBER AGENCY_PAN_NUMBER,
  cl.PAN_NUMBER CLIENT_PAN_NUMBER,
  if(ag.id is not null, ag.PAN_NUMBER, cl.PAN_NUMBER) PAN_NUMBER,
  inv.CAMPAIGN_ID,
  ad.DEAL_ID
from
  sales_tally.invoice_details invd
  left outer join AMAGI_REPORTS_DB.INVOICES inv
    on invd.invoice_number = inv.invoice_number
  left outer join AMAGI_REPORTS_DB.ATS_CAMPAIGNS cmp
    on inv.campaign_id = cmp.campaign_id
  left outer join AMAGI_REPORTS_DB.ATS_DEALS ad
    on cmp.deal_id = ad.deal_id
  left outer join AMAGI_SALES_DB.SALES_PERSONS sp
    on ad.AMAGI_CONTACT_EMAIL_ID = sp.mail_id
  left outer join AMAGI_SALES_DB.SALES_PERSONS sp2
    on sp.manager_mail_id = sp2.mail_id
  left outer join AMAGI_REPORTS_DB.ATS_CLIENTS cl
    on ad.client_id = cl.id
  left outer join AMAGI_REPORTS_DB.ATS_AGENCIES ag
    on ad.agency_id = ag.id
where
  invd.invoice_number like '{invoice_number}' and
  invd.client_name like '{client_name}' and
  invd.agency_name like '{agency_name}' and
  ad.sales_office like '{sales_region}' and
  '{start_date}' <= invd.invoice_date and
  invd.invoice_date <= '{end_date}' and
  invd.status != 'D'
  
  
