class NagerService

  def get_next_holidays(country_code)
    @get_next_holidays ||= {}
    @get_next_holidays[country_code] ||= get_url("https://date.nager.at/api/v3/NextPublicHolidays/#{country_code}")
  end

  def get_url(url)
    response = Faraday.get(url)
    puts '<-------- A REQUEST HAS BEEN MADE -------->'

    JSON.parse(response.body)
  end

end
