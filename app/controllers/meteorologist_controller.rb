require 'open-uri'

class MeteorologistController < ApplicationController
  def street_to_weather_form
    # Nothing to do here.
    render("meteorologist/street_to_weather_form.html.erb")
  end

  def street_to_weather
    @street_address = params[:user_street_address]

    # ==========================================================================
    # Your code goes below.
    #
    # The street address that the user typed is in the variable @street_address.
    # ==========================================================================

    input = @street_address.gsub(" ","+")
    mapurl = "https://maps.googleapis.com/maps/api/geocode/json?address="+input
    map_parsed_data = JSON.parse(open(mapurl).read)
    @latitude = map_parsed_data["results"][0]["geometry"]["location"]["lat"]
    @longitude = map_parsed_data["results"][0]["geometry"]["location"]["lng"]

    weatherurl = "https://api.darksky.net/forecast/86fe11a0844735f174110c6dc1bbd607/"+@latitude.to_s+","+@longitude.to_s
    
    parsed_data = JSON.parse(open(weatherurl).read)

    @current_temperature = parsed_data["currently"]["temperature"]

    @current_summary = parsed_data["currently"]["summary"]

    @summary_of_next_sixty_minutes = parsed_data["minutely"]["summary"]

    @summary_of_next_several_hours = parsed_data["hourly"]["summary"]

    @summary_of_next_several_days = parsed_data["daily"]["summary"]

    render("meteorologist/street_to_weather.html.erb")
  end
end
