#encoding: utf-8
require 'open-uri'

module WeatherHelper
  def get_weather_from_city(city)
    json = open("http://free.worldweatheronline.com/feed/weather.ashx?q=" + city + ",France&format=json&date=today&key=b4fd26ce78222904120612").read
    results = JSON.parse json
    {
      temp_max:  results["data"]["weather"][0]["tempMaxC"],
      temp_min:  results["data"]["weather"][0]["tempMinC"],
      desc:  results["data"]["weather"][0]["weatherDesc"][0]["value"],
      icon:  results["data"]["weather"][0]["weatherIconUrl"][0]["value"],
    }
  end
end
