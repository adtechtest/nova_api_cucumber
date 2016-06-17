class InvoiceDetail < ActiveRecord::Base
  self.primary_key = "invoice_number"
 
  belongs_to :client, class_name: AgencyClient, foreign_key: "CLIENT_NAME", primary_key: "Name"
  belongs_to :agency, class_name: AgencyClient, foreign_key: "AGENCY_NAME", primary_key: "Name"

  def self.to_map(inv)
    map = {}

    map['invoice_number'] = inv['INVOICE_NUMBER']
    map['invoice_date'] = inv['INVOICE_DATE']
    map['client_name'] = inv['CLIENT_NAME']
    map['client_address_1'] = inv['CLIENT_ADDRESS_LINE_1']
    map['client_address_2'] = inv['CLIENT_ADDRESS_LINE_2']
    map['client_address_3'] = inv['CLIENT_ADDRESS_LINE_3']
    map['agency_name'] = inv['AGENCY_NAME']
    map['agency_address_1'] = inv['AGENCY_ADDRESS_LINE_1']
    map['agency_address_2'] = inv['AGENCY_ADDRESS_LINE_2']
    map['agency_address_3'] = inv['AGENCY_ADDRESS_LINE_3']
    map['telecast_start_date'] = inv['START_DATE']
    map['telecast_end_date'] = inv['END_DATE']
    map['telecast_period'] = inv['PERIOD']
    map['campaign_name'] = inv['CAMPAIGN']
    map['target_city'] = inv['TARGET_CITY']
    map['invoice_start_date'] = inv['START_DATE_L']
    map['invoice_end_date'] = inv['END_DATE_L']
    map['channel'] = inv['CHANNEL']
    map['spot_duration'] = inv['SPOT_DURATION']
    map['total_secondages'] = inv['TOTAL_SECONDAGES']
    map['spot_count'] = inv['SPOT_COUNT']
    map['gross_total'] = inv['GROSS_TOTAL']
    map['total_after_slab_discount'] = inv['TOTAL_AFTER_SLAB_DIS']
    map['slab_discount_percentage'] = inv['SLAB_DISCOUNT_PRCT']
    map['slab_discount_amount'] = inv['SLAB_DISCOUNT_AMT']
    map['agency_discount_percentage'] = inv['AGENCY_DISCOUNT_PRCT']
    map['agency_discount_amount'] = inv['AGENCY_DICSOUNT_AMT']
    map['net_amount'] = inv['NET_AMT']
    map['service_tax_percentage'] = inv['SERVICE_TAX_PRCT']
    map['service_tax_amount'] = inv['SERVICE_TAX_AMT']
    map['education_cess_tax_percentage'] = inv['EDUCATION_CESS_TAX_PRCT']
    map['education_cess_tax_amount'] = inv['EDUCATION_CESS_TAX_AMT']
    map['higher_education_cess_tax_percentage'] = inv['HigherEducationCessPercentage']
    map['higher_education_cess_amount'] = inv['HIGHER_EDUCATION_CESS_AMT']
    map['invoice_amount'] = inv['INVOICE_AMT']
    map['amount_in_words'] = inv['AMT_IN_WORDS']
    map['status'] = inv['STATUS']
    map['caption_name'] = inv['CAPTION_NAME']
    map['client_mail_ids'] = inv['MAILID'] ? inv['MAILID'].strip.gsub(',', ' ').gsub(/\s+/, ', ') : ''
    map['category'] = inv['CATEGORY']
    map['payment_due_date'] = inv['PAYMENT_DUE_DATE']
    map['ad_category'] = 'Target Television Advertisement'
    map['ad_type'] = inv['CAMPAIGNCITY'] != 'Master' ? 'Local' : 'Master'
 
    map['sales_region'] = inv['SALES_OFFICE'] || ''
    map['team_member'] = inv['SALES_MEMBER_NAME'] || ''
    map['team_member_name'] = inv['SALES_MEMBER_NAME'] || ''
    map['team_member_mail_id'] = inv['SALES_MEMBER_MAIL_ID'] || ''
    map['team_lead'] = inv['TEAM_LEAD_NAME'] || ''
    map['team_lead_name'] = inv['TEAM_LEAD_NAME'] || ''
    map['team_lead_mail_id'] = inv['TEAM_LEAD_MAIL_ID'] || ''
    map['brand_name'] = inv['BRAND_NAME'] || ''
    map['agency_pan_number'] = inv['AGENCY_PAN_NUMBER'] || ''
    map['client_pan_number'] = inv['CLIENT_PAN_NUMBER'] || ''
    map['pan_number'] = inv['PAN_NUMBER'] || ''
    map['campaign_id'] = inv['CAMPAIGN_ID'] || ''
    map['deal_id'] = inv['DEAL_ID'] || ''

    return map
  end
end
