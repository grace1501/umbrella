require "http"
require "json"

gmap_key = ENV.fetch("GMAPS_KEY")

puts "Where are you?"
location = gets.chomp
# location = "Columbus"

location_address = location.gsub(" ", "%20")
map_res = HTTP.get("https://maps.googleapis.com/maps/api/geocode/json?address=#{location_address}&key=#{gmap_key}")
parsed_map = JSON.parse(map_res)

user_lat = parsed_map["results"][0].fetch("geometry").fetch("location").fetch("lat")
user_lng = parsed_map.fetch("results")[0].fetch("geometry").fetch("location").fetch("lng")

pirate_weather_key = ENV.fetch("PIRATE_WEATHER_KEY")
weather_url = "https://api.pirateweather.net/forecast/#{pirate_weather_key}/#{user_lat},#{user_lng}"
weather_res = HTTP.get(weather_url)
weather_json = JSON.parse(weather_res)

weather_url_si = "#{weather_url}?units=si"
weather_res_si = HTTP.get(weather_url_si)
weather_json_si = JSON.parse(weather_res_si)

current_temp = weather_json.fetch("currently").fetch("temperature")
current_temp_si = weather_json_si.fetch("currently").fetch("temperature")

next_hour_weather = weather_json.fetch("hourly").fetch("summary")

puts "You are in #{location}. 
The current temperature is #{current_temp} F, #{current_temp_si} C. 
The weather for the next hour is #{next_hour_weather}"

hourly_weather_array = weather_json.fetch("hourly").fetch("data")
will_rain = false

hourly_weather_array[0...12].each_with_index {|hour, index|
  chance_of_rain = (hour.fetch("precipProbability")*100).to_i

  if chance_of_rain > 10
    will_rain = true
    puts "In #{index} hour, there is #{chance_of_rain}% chance of rain."
  end  
}

if will_rain == true 
  puts "You might want to take an umbrella!"
else
    puts "You don't need an umbrella."
end
