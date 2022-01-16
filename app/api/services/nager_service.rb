class NagerService < Service

  def get_next_holidays(country_code)
    get_url("https://date.nager.at/api/v3/NextPublicHolidays/#{country_code}")
  end

end
