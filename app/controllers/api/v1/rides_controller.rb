require 'httparty'

class Api::V1::RidesController< ApplicationController
  def index
    driver = Driver.find(params[:driver_id])
    rides = Ride.where(driver_id: nil)
      .includes(:driver)
      .map { |ride| [ride, ride.score(driver)] }
      .sort_by { |ride, score| - score   }
      .map { |ride, _| ride }

    total_count = rides.count
    paginated_rides = Kaminari.paginate_array(rides).page(params[:page]).per(params[:per_page])
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
