class Ride < ApplicationRecord
  belongs_to :driver, optional: true
  validates_presence_of :start_address, :destination_address

  private

  def get_directions(origin, destination, driver)
    return nil if origin.nil? || destination.nil? || driver.nil? || driver.home_address.nil?
    origin = "#{URI.encode_www_form_component(origin)},#{URI.encode_www_form_component(driver.home_address)}"
    destination = "#{URI.encode_www_form_component(destination)}"
    mode = 'driving'
    api_key = ENV['GOOGLE_MAPS_API_KEY']
    url = "https://maps.googleapis.com/maps/api/directions/json?origin=#{origin}&destination=#{destination}&mode=#{mode}&key=#{api_key}"
    response = HTTParty.get(url)
    Rails.cache.fetch("#{origin}/#{destination}", expires_in: 1.hour) do
      response
    end
    response["routes"][0]["legs"][0]
  end
end