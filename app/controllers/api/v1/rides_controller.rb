require 'httparty'

class Api::V1::RidesController< ApplicationController
  def index
    render json: Ride.all.where(driver_id: nil)
  end
end