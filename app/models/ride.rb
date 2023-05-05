class Ride < ApplicationRecord
  belongs_to :driver, optional: true
  validates_presence_of :start_address, :destination_address

  def score(driver)
    ride_earnings(driver) / (commute_duration(driver) + ride_duration(driver))
  end

  def ride_earnings(driver)
    @ride_earnings ||= begin
      base_earnings = 12
      mileage_pay = (ride_distance(driver) - 5) * 1.5
      time_pay = (ride_duration(driver) - 15) * 0.7
      [base_earnings + mileage_pay + time_pay, 0].max
    end
  end

  def commute_distance(driver)
    @commute_distance ||= begin
      origin = driver.home_address
      destination = start_address
      get_directions(origin, destination, driver)["distance"]["value"] / 1609.344
    end
  end

  def commute_duration(driver)
    @commute_duration ||= begin
      origin = driver.home_address
      destination = start_address
      get_directions(origin, destination, driver)["duration"]["value"] / 3600.0
    end
  end

  def ride_distance(driver)
    @ride_distance ||= begin
      origin = start_address
      destination = destination_address
      get_directions(origin, destination, driver)["distance"]["value"] / 1609.344
    end
  end

  def ride_duration(driver)
    @ride_duration ||= begin
      origin = start_address
      destination = destination_address
      get_directions(origin, destination, driver)["duration"]["value"] / 3600.0
    end
  end

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