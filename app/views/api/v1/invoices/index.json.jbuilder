json.status @status

  json.invoices do 
    json.array! @data do |invoice|
      invoice.to_map.each do |key, value|
        json.set! key, value
      end
    end
  end

json.error @error
