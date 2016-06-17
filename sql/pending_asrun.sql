select 
    P.sch_date,
    P.channel_code,
    P.city_code,
    P.caption_id,
    P.deal_id,
    P.campaign_id,
    P.scheduled_count,
    P.ad_name as creative_id,
    IFNULL(Q.played_count,0) as played_count,
    (P.scheduled_count - IFNULL(Q.played_count,0)) as pending_count
from
    (select 
        smb.sch_date,
            smb.channel_code,
            smla.city_code,
            smla.caption_id,
            smla.ad_name,
            cmp.campaign_id,
            cmp.deal_id,
            count(*) as scheduled_count
    from
        AMAGI_REPORTS_DB.SCH_MATRIX_BREAKS smb
    left outer join AMAGI_REPORTS_DB.SCH_MATRIX_LOCAL_ADS smla ON smb.id = smla.sch_matrix_brk_id
    left outer join AMAGI_REPORTS_DB.ATS_CAPTIONS cap ON smla.caption_id = cap.caption_id
    left outer join AMAGI_REPORTS_DB.ATS_CAMPAIGNS cmp ON cap.campaign_id = cmp.campaign_id
    left outer join AMAGI_REPORTS_DB.ATS_DEALS ad ON cmp.deal_id = ad.deal_id
    where
        smb.sch_date >= '{start_date}'
            and smb.sch_date <= '{end_date}'
            and smb.channel_code = '{channel_code}'
            and smla.caption_id != '000000000000'
            and smla.caption_id like '{caption_id}'
            and cmp.campaign_id like '{campaign_id}'
            and ad.deal_id like '{deal_id}'
    group by  channel_code ,sch_date , deal_id, campaign_id,  caption_id , ad_name ,   city_code
    order by smb.channel_code, smb.sch_date , cmp.deal_id, cmp.campaign_id, smla.caption_id , smla.ad_name, smla.city_code) P
        left outer join
    (select 
        aps.date as sch_date,
            ad.deal_id,
            cmp.campaign_id,
            aps.caption_id,
            aps.channel_code,
            aps.city_code,
            cap.ad_name as creative_id,
            sum(played_rotates) as played_count
    from
        AMAGI_REPORTS_DB.AD_PLAY_STATUSES aps
    left outer join AMAGI_REPORTS_DB.ATS_CAPTIONS cap ON aps.caption_id = cap.caption_id
    left outer join AMAGI_REPORTS_DB.ATS_CAMPAIGNS cmp ON cap.campaign_id = cmp.campaign_id
    left outer join AMAGI_REPORTS_DB.ATS_DEALS ad ON cmp.deal_id = ad.deal_id
    left outer join AMAGI_REPORTS_DB.ATS_CLIENTS ac ON ad.client_id = ac.id
    where
        aps.date >= '{start_date}'
            and aps.date <= '{end_date}'
            and aps.caption_id like '{caption_id}'
            and cmp.campaign_id like '{campaign_id}'
            and ad.deal_id like '{deal_id}'
            and aps.channel_code = '{channel_code}'
    group by  aps.channel_code, sch_date , ad.deal_id, cmp.campaign_id, aps.caption_id, creative_id,aps.city_code       
    order by aps.channel_code, sch_date , ad.deal_id, cmp.campaign_id, aps.caption_id, creative_id,aps.city_code) Q 
    ON P.sch_date = Q.sch_date
        and P.channel_code = Q.channel_code
        and P.caption_id = Q.caption_id
        and P.city_code = Q.city_code
        and P.deal_id = Q.deal_id
        and P.campaign_id = Q.campaign_id
     having pending_count > 0   
;
