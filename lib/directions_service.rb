class DirectionsService 
  def initialize
    @api_key = ENV['GOOGLE_MAPS_API_KEY']
  end

  def get_directions(origin, destination, driver)
    origin = prepare_origin(origin, driver.home_address)
    destination = URI.encode_www_form_component(destination)
    url = "https://maps.googleapis.com/maps/api/directions/json?origin=#{origin}&destination=#{destination}&mode=driving&key=#{@api_key}"
    response = HTTParty.get(url)

    Rails.cache.fetch("#{origin}/#{destination}", expires_in: 1.hour) do
      response
    end

    response["routes"][0]["legs"][0]
  end

  private

  def prepare_origin(origin, home_address)
    "#{URI.encode_www_form_component(origin)},#{URI.encode_www_form_component(home_address)}"
  end
end