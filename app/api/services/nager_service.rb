class NagerService
  def self.get_next_holidays
    get_url("https://date.nager.at/api/v3/NextPublicHolidays/US")
  end

  def self.get_url(url)
    response = Faraday.get(url)

    JSON.parse(response.body)
  end
end
