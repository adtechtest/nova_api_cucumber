
FactoryGirl.define do
  factory :ats_caption do
    CAPTION_NAME 'caption1'
  end
  
  factory :ats_campaign do
    NAME 'campaign1'
  end

  factory :ats_deal do
    FILE_NAME 'file1'
  end

  factory :con_as_played_status do
  end

  factory :ats_rotate_plan do
  end

  factory :schedule do
    AD_TYPE 'LVA'
    WIN_BEGIN '06:00:00'
    WIN_END '12:59:59'
    PRELOAD_TIME '00:00:00'
    PREROLL_TIME '00:00:00'
    INGEST_TYPE 'LVA'
    BREAK_NUMBER 1
    ISLAND_NUMBER 1
    SEQ_IN_ISLAND 1
    AD_NAME 'ABC110'
    CAMPAIGN_NAME 'camp1'
  end

  factory :ad_play_status do
  end
end
