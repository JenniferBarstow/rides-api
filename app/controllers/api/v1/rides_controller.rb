require 'httparty'
require 'directions_service'
require 'ride_calculator'

class Api::V1::RidesController< ApplicationController
  def index
    driver = Driver.find(params[:driver_id])
    rides = Ride.where(driver_id: nil)
    calculators = rides.map { |ride| RideCalculator.new(ride, driver) }
    filtered_calculators = calculators.filter do |calculator| 
      begin
        calculator.score
       # we dont want a 500 error if one of them fails.
       # if there are any failures in the score for a ride, then dont include it 
      rescue 
        false
      end
    end

    sorted_calculators = filtered_calculators.sort_by(&:score)
    sorted_rides = sorted_calculators.map { |calculator| calculator.ride }

    total_count = rides.count
    paginated_rides = Kaminari.paginate_array(sorted_rides).page(params[:page]).per(params[:per_page])
    rides_json = paginated_rides.as_json(except: [:created_at, :updated_at, :driver_id])

    render json: {
      rides: rides_json,
      total_count: total_count,
      links: pagination_links(paginated_rides)
    }
  end

  private

  def pagination_links(collection)
    {
      self: request.original_url,
      next: collection.next_page.nil? ? nil : request.base_url + "/api/v1/rides?driver_id=#{params[:driver_id]}&page=#{collection.next_page}&per_page=#{params[:per_page]}",
      prev: collection.prev_page.nil? ? nil : request.base_url + "/api/v1/rides?driver_id=#{params[:driver_id]}&page=#{collection.prev_page}&per_page=#{params[:per_page]}"
    }.compact
  end
end
