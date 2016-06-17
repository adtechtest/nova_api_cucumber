class Api::V1::InvoicesController < ApplicationController
  before_filter :authenticate

  api :GET, "/v1/invoices.json", "Returns list of invoices"
  param :limit, :number, :desc => "No of results to return"
  param :offset, :number, :desc => "No of rows to skip"
  example <<-EOS
    INPUT:
      http://nova.amagi.com/api/v1/invoices.json?start_date=2015-04-01&end_date=2015-04-15&limit=10
    OUTPUT:
      {
        "status": 0,
        "invoices": [
          {
            "invoice_number": "AMG-000001/15-16",
            "invoice_date": "2015-04-06",
            "client_name": "Laborate Pharmaceuticals India Ltd.",
            "client_address_1": "E-11, Industrial Area,",
            "client_address_2": "",
            "client_address_3": "Panipat  ",
            "agency_name": "Craazea Media Labs",
            "agency_address_1": "E-46, Sector 52, Ardee City,",
            "agency_address_2": "",
            "agency_address_3": "Gurgaon Haryana 122001",
            "telecast_start_date": "2015-04-01",
            "telecast_end_date": "2015-04-06",
            "telecast_period": "01-Apr-2015 to 06-Apr-2015",
            "campaign_name": "Labolia Men s Fairness cream",
            "target_city": "Delhi UP DTH Bihar Punjab Jharkhand Jammu Kashmir",
            "invoice_start_date": "2015-04-01",
            "invoice_end_date": "2015-04-15",
            "channel": "Zee News",
            "spot_duration": "15",
            "total_secondages": "780",
            "spot_count": "52",
            "gross_total": 104520.0,
            "total_after_slab_discount": 104520.0,
            "slab_discount_percentage": 0.0,
            "slab_discount_amount": 0.0,
            "agency_discount_percentage": 0.0,
            "agency_discount_amount": 0.0,
            "net_amount": 104520.0,
            "service_tax_percentage": 0.12,
            "service_tax_amount": 12542.4,
            "education_cess_tax_percentage": 0.02,
            "education_cess_tax_amount": 250.85,
            "higher_education_cess_tax_percentage": 0.01,
            "higher_education_cess_amount": 125.42,
            "invoice_amount": 117438.67,
            "amount_in_words": " Rupees One lakh seventeen thousand four hundred thirty eight and paise sixty seven only",
            "status": "A",
            "caption_name": "Labolia Men s Fairness cream",
            "client_mail_ids": "",
            "category": "Target Television Advertisement",
            "payment_due_date": "2015-04-09",
            "ad_category": "Target Television Advertisement",
            "ad_type": "Master",
            "sales_region": "Delhi Retail",
            "team_member": "neeraj@amagi.com",
            "brand_name": "abcd",
            "pan_number": "pan_number_1"
          }
        ]
      }
  EOS
  def index
    headers['Access-Control-Allow-Origin'] = '*'
    start_date = params[:start_date]
    if start_date.nil? or (start_date =~ /^\d{4}-\d{2}-\d{2}$/).nil?
      @status = 1
      @error = "start_date '#{start_date}' is invalid"
      return
    end

    end_date = params[:end_date]
    if end_date.nil? or (end_date =~ /^\d{4}-\d{2}-\d{2}$/).nil?
      @status = 1
      @error = "end_date '#{end_date}' is invalid"
      return
    end
      
    date_format = I18n.t "date.formats.js"
    begin 
      start_date_d = DateTime.strptime(start_date, date_format)
    rescue
      @status = 1
      @error = "start_date should be in #{date_format} format"
    end
    begin 
      end_date_d = DateTime.strptime(end_date, date_format)
    rescue
      @status = 1
      @error = "start_date should be in #{date_format} format"
    end

    salesregion = params[:sales_region]
    if salesregion.blank?
      salesregion = "%"
    end

    client_or_agency_type = params[:client_or_agency_type]
    agency_name = params[:client_or_agency_name]
    if client_or_agency_type != 'agency' or agency_name.blank?
      agency_name = "%"
    end

    client_name = params[:client_or_agency_name]
    if client_or_agency_type != 'client' or client_name.blank?
      client_name = "%"
    end

    invoice_number = params[:invoice_number]
    if invoice_number.blank?
      invoice_number = "%"
    end

    query = File.read('sql/invoices.sql')
    query.sub! '{invoice_number}', invoice_number
    query.sub! '{client_name}', client_name
    query.sub! '{agency_name}', agency_name
    query.sub! '{start_date}', start_date
    query.sub! '{end_date}', end_date
    query.sub! '{sales_region}', salesregion

    con = ActiveRecord::Base.connection
    print query;
    @invoices = con.exec_query(query)

    result = {}
    result["status"] = 0
    result["invoices"] = []
    @invoices.each do |invoice|
      result["invoices"].push InvoiceDetail.to_map(invoice)
    end

    render :json => result.to_json
  end

  def salesregions
    headers['Access-Control-Allow-Origin'] = '*'
    @sales_regions = InvoiceDetail.select(:CAMPAIGNCITY).where("CAMPAIGNCITY is not null and TRIM(CAMPAIGNCITY) != ''").order(:CAMPAIGNCITY).distinct
    @data = []
    @sales_regions.each do |sales_region|
      @data.push sales_region["CAMPAIGNCITY"]
    end
    @status = 0
    @error = ""
  end

  def update
    headers['Access-Control-Allow-Origin'] = '*'
    role = params[:role]
    invoice_number = params[:invoice_number]   
    action = params[:action_type]

    @error = ""
    @status = 1
    if role != "traffic" and role != "finance"
      @error = "invalid role '#{role}'"
      return
    end
    if action != "approve" and action != "reject"
      @error = "invalid action '#{action}'"
      return
    end

    if role == "traffic"
      state = action == "approve" ? "Y" : "D"
    elsif role == "finance"
      state = action == "approve" ? "A" : "D"
    end

    inv = InvoiceDetail.where("invoice_number = ? and status != 'D'", invoice_number).last
    if inv.nil?
      @error = "Invoice #{invoice_number} not present"
      return
    end

    @status = 0
    ActiveRecord::Base.connection.execute("update invoice_details set status = '#{state}' where invoice_number = '#{invoice_number}'")
    if state == "D"
      ActiveRecord::Base.connection.execute("update AMAGI_REPORTS_DB.INVOICES set deleted = 'Y' where invoice_number = '#{invoice_number}'")
    end
  end

  def tc
    headers['Access-Control-Allow-Origin'] = '*'
    invoice_number = params[:invoice_number]
    invoice = Invoice.find(invoice_number)
    campaign_id = invoice["CAMPAIGN_ID"]
    start_date = invoice["START_DATE"]
    end_date = invoice["END_DATE"]
    channel_code = invoice["CHANNEL_CODE"]
   
    query = File.read('sql/tc.sql')
    query.sub! '{invoice_number}', invoice_number

    @invoice_number = invoice_number
    con = ActiveRecord::Base.connection
    print query;
    @asruns = con.exec_query(query)
    @count = 0
    @asruns.each do |a|
      @count = @count+1
    end
  end
 
  def authenticate
    headers['Access-Control-Allow-Origin'] = '*'
    authenticate_or_request_with_http_basic('Administration') do |username, password|
      username == Rails.configuration.billing_system.username && password == Rails.configuration.billing_system.password
    end
  end
end
