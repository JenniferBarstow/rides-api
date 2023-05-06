require 'rails_helper'
require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = 'spec/vcr_cassettes'
  config.filter_sensitive_data('<GOOGLE_MAPS_API_KEY>') {ENV['GOOGLE_MAPS_API_KEY'] }
  config.hook_into :webmock
end


RSpec.describe "Api::V1::RidesController", type: :request do
  describe "GET /api/v1/rides" do
    let(:driver) { Driver.create(home_address: '123 Main St, Anytown USA') }

    it "returns http success" do
      VCR.use_cassette('rides_index') do
        get "/api/v1/rides?driver_id=#{driver.id}"
        expect(response).to have_http_status(:success)
      end
    end

    it "returns correct JSON response" do
      VCR.use_cassette('rides_index') do
        ride = Ride.create(start_address: '456 Elm St, Anytown USA', destination_address: '789 Oak St, Anytown USA')
        get "/api/v1/rides?driver_id=#{driver.id}"
        expected_response = {
          "rides" => [{
            "id" => ride.id,
            "start_address" => ride.start_address,
            "destination_address" => ride.destination_address,
          }],
          "total_count" => 1,
          "links" => {
            "self" => "http://www.example.com/api/v1/rides?driver_id=#{driver.id}",
          }
        }
        expect(JSON.parse(response.body)).to eq(expected_response)
      end
    end
  end
end
