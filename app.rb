require "http"
require "json"

gmap_key = ENV.fetch("GMAPS_KEY")

puts "Where are you?"
# location = gets.chomp
location = "Chicago"

location_address = location.gsub(" ", "%20")
map_res = HTTP.get("https://maps.googleapis.com/maps/api/geocode/json?address=#{location_address}&key=#{gmap_key}")
parsed_map = JSON.parse(map_res)

user_lat = parsed_map["results"][0].fetch("geometry").fetch("location").fetch("lat")
user_lng = parsed_map.fetch("results")[0].fetch("geometry").fetch("location").fetch("lng")

pirate_weather_key = ENV.fetch("PIRATE_WEATHER_KEY")
weather_url = "https://api.pirateweather.net/forecast/#{pirate_weather_key}/#{user_lat},#{user_lng}"
weather_res = HTTP.get(weather_url)
weather_json = JSON.parse(weather_res)


