require 'rails_helper'

RSpec.describe Ride, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:start_address) }
    it { should validate_presence_of(:destination_address) }
  end

  let(:driver) { Driver.create(home_address: '123 Main St, Anytown USA') }
  let(:ride) { Ride.create(start_address: '456 Elm St, Anytown USA', destination_address: '789 Oak St, Anytown USA') }

  describe '#get_directions' do
    it 'returns the correct directions for a given origin and destination' do
      allow(HTTParty).to receive(:get)
        .and_return({"routes"=>[{"legs"=>[{"distance"=>{"value"=>16093}, "duration"=>{"value"=>2700}}]}]})
      expect(ride.send(:get_directions, ride.start_address, ride.destination_address, driver))
        .to eq({"distance"=>{"value"=>16093}, "duration"=>{"value"=>2700}})
    end
  end
end