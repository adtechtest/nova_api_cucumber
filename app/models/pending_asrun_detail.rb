class PendingAsrunDetail < ActiveRecord::Base
 
  def self.to_map(rec)
    map = {}

    map['deal_id'] = rec['deal_id']
    map['campaign_id'] = rec['campaign_id']
    map['caption_id'] = rec['caption_id']
    map['channel_code'] = rec['channel_code']
    map['creative_id'] = rec['creative_id']
    map['date'] = rec['sch_date']
    map['spot_count'] = rec['pending_count']

    return map
  end
end
