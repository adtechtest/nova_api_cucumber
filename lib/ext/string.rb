class String
  
  def to_sql_formatted_date
    begin
      str_date = self.to_datetime.strftime("%Y-%m-%d %H:%M:%S")
    rescue
      str_date = ""
    end
    return str_date
  end

  def is_number?
    true if Float(self) rescue false
  end

end