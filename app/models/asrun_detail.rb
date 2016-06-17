class AsrunDetail < ActiveRecord::Base
 
  def self.to_map(inv)
    map = {}

    map['deal_id'] = inv['deal_id']
    map['campaign_id'] = inv['campaign_id']
    map['caption_id'] = inv['caption_id']
    map['channel_code'] = inv['channel_code']
    map['city_code'] = inv['city_code']
    map['creative_id'] = inv['creative_id']
    map['date'] = inv['sch_date']
    map['daypart'] = inv['daypart']
    map['spot_count'] = inv['spot_count']
    map['aired_times'] = inv['aired_times']

    return map
  end
end
