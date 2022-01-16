class NagerData

  def next_holiday_name
    @get_next_holidays ||= NagerService.get_next_holidays
    @get_next_holidays[0]["localName"]
  end

  def next_holidays(amount) # Returns the name and date of the next N holidays
    @get_next_holidays ||= NagerService.get_next_holidays
    @get_next_holidays.first(amount).map do |holiday|
      {
        name: holiday["localName"],
        date: holiday["date"]
      }
    end
  end

end
