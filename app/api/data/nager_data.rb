class NagerData

  def next_holiday_name(country_code)
    data = service.get_next_holidays(country_code)
    data[0]["localName"]
  end

  def next_holidays(country_code, amount) # Returns the name and date of the next N holidays
    data = service.get_next_holidays(country_code)
    data.first(amount).map do |holiday|
      {
        name: holiday["localName"],
        date: holiday["date"]
      }
    end
  end


  private

  def service
    @service ||= NagerService.new
  end

end
