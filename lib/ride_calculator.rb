require 'directions_service'

class RideCalculator

  attr_accessor :ride

  def initialize(ride, driver)
    @ride = ride
    @driver = driver
    @directions_service = DirectionsService.new
  end

  def score
    @score ||= ride_earnings / (commute_duration + ride_duration)
  end

  def ride_earnings
    @ride_earnings ||= begin
      base_earnings = 12
      mileage_pay = (ride_distance - 5) * 1.5
      time_pay = (ride_duration - 15) * 0.7
      [base_earnings + mileage_pay + time_pay, 0].max
    end
  end

  def commute_distance
    @commute_distance ||= begin
      origin = @driver.home_address
      destination = @ride.start_address
      @directions_service.get_directions(origin, destination, @driver)["distance"]["value"] / 1609.344
    end
  end

  def commute_duration
    @commute_duration ||= begin
      origin = @driver.home_address
      destination = @ride.start_address
      @directions_service.get_directions(origin, destination, @driver)["duration"]["value"] / 3600.0
    end
  end

  def ride_distance
    @ride_distance ||= begin
      origin = @ride.start_address
      destination = @ride.destination_address
      @directions_service.get_directions(origin, destination, @driver)["distance"]["value"] / 1609.344
    end
  end

  def ride_duration
    @ride_duration ||= begin
      origin = @ride.start_address
      destination = @ride.destination_address
      @directions_service.get_directions(origin, destination, @driver)["duration"]["value"] / 3600.0
    end
  end

end