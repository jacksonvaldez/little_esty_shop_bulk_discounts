class NagerData

  def next_holidays(amount) # Returns the name and date of the next N holidays
    @_data ||= service.get_next_holidays
    @_data.first(amount).map do |holiday|
      {
        name: holiday["localName"],
        date: holiday["date"]
      }
    end
  end

  def service
    @_service ||= NagerService.new
  end

end
