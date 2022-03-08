class HolidayApi

  def conn 
    Faraday.new(url: "https://date.nager.at")
  end

  def upcoming_holidays(count)

    resp = conn.get("api/v3/NextPublicHolidays/US")
    json = JSON.parse(resp.body, symbolize_names: true)
    json.each do |holiday|
      existing_holiday = Holiday.where(name: holiday[:name], date: holiday[:date])
      if existing_holiday.count == 0
        Holiday.create!(name: holiday[:name], 
                        date: holiday[:date])
      end
    end
    json[0...count]
  end
end