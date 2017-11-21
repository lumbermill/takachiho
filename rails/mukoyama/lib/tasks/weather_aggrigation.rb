require "json"
require "open-uri"
require 'logger'

# Provided by http://openweathermap.org/
$api_key = ENV['WEATHER_KEY']
BASE_URL = "http://api.openweathermap.org/data/2.5/"
$log = Logger.new(File.join(Rails.root, 'log', "weather_aggrigation.log"),10,1024000)

def get_weather(id)
  query = "?id=#{id}&units=metric&appid=#{$api_key}"
  url = BASE_URL + "weather/" + query
  puts url[0,78]+" .."
  response = open(url)
  json = JSON.parse(response.read)
  yield(json)
end

def aggregate(id)
  get_weather(id) do |weather|
    w_dt = Time.at(weather["dt"])
    w = Weather.where("dt = ? and id = ?", w_dt, id)
    unless(w.present?)
      w = Weather.new
      w.dt = w_dt
      w.id = id
      w.weather_main = weather["weather"][0]["main"]
      w.weather_desc = weather["weather"][0]["description"]
      w.temp = weather["main"]["temp"]
      w.pressure = weather["main"]["pressure"]
      w.humidity = weather["main"]["humidity"]
      w.wind_speed = weather["wind"]["speed"]
      w.wind_deg = weather["wind"]["deg"]
      w.cloudiness = weather["clouds"]["all"]
      w.rain = weather["rain"] ? weather["rain"]["3h"] : "null"
      w.snow = weather["snow"] ? weather["snow"]["3h"] : "null"
      w.modified_at = Time.now()
      w.save
    else
      $log.info("weather already gotten. (dt:#{w_dt}, id:#{id} #{Mukoyama::CITY_IDS.invert[id]})")
    end
  end
end

Mukoyama::CITY_IDS.values.each do |city_id|
  begin
    aggregate(city_id)
  rescue => e
    $log.error("aggrigation failed. (id:#{city_id} #{Mukoyama::CITY_IDS.invert[city_id]})")
    $log.error(e)
  end
end
