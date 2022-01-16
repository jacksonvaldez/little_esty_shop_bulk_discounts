class NagerData

  def next_holiday_name
    data = service.get_next_holidays
    data[0]["localName"]
  end

  def next_holidays(amount) # Returns the name and date of the next N holidays
    data = service.get_next_holidays
    data.first(amount).map do |holiday|
      {
        name: holiday["localName"],
        date: holiday["date"]
      }
    end
  end

  def service
    @service ||= NagerService.new
  end

end
