require 'rails_helper'

RSpec.describe Ride, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:start_address) }
    it { should validate_presence_of(:destination_address) }
  end

  let(:driver) { Driver.create(home_address: '123 Main St, Anytown USA') }
  let(:ride) { Ride.create(start_address: '456 Elm St, Anytown USA', destination_address: '789 Oak St, Anytown USA') }

  describe '#score' do
    it 'returns the correct score' do
      # ride_earnings(driver) / (commute_duration(driver) + ride_duration(driver))
      allow(ride).to receive(:ride_earnings).with(driver).and_return(20)
      allow(ride).to receive(:commute_duration).with(driver).and_return(5)
      allow(ride).to receive(:ride_duration).with(driver).and_return(5)

      expect(ride.score(driver)).to eq(2)
    end
  end

  describe '#ride_earnings' do
  # base_earnings = 12, mileage_pay = 5 * 1.5, time_pay = 5 * 0.7
  # base_earnings + mileage_pay + time_pay
    it 'returns the correct ride earnings' do
      allow(ride).to receive(:ride_distance).with(driver).and_return(10)
      allow(ride).to receive(:ride_duration).with(driver).and_return(20)

      expect(ride.ride_earnings(driver)).to eq(23)
    end
  end

  describe '#commute_distance' do
    it 'returns the correct commute distance' do
      allow(ride).to receive(:get_directions).with(driver.home_address, ride.start_address, driver)
        .and_return({'distance' => {'value' => 80467}})
      expect(ride.commute_distance(driver)).to eq(49.99987572576155)
    end
  end

  describe '#commute_duration' do
    it 'returns the correct commute duration' do
      allow(ride).to receive(:get_directions).with(driver.home_address, ride.start_address, driver)
        .and_return({'duration' => {'value' => 5400}})
      expect(ride.commute_duration(driver)).to eq(1.5)
    end
  end

  describe '#ride_distance' do
    it 'returns the correct ride distance' do
      allow(ride).to receive(:get_directions).with(ride.start_address, ride.destination_address, driver)
        .and_return({'distance' => {'value' => 16093}})
      expect(ride.ride_distance(driver)).to eq(9.999726596675416)
    end
  end

  describe '#ride_duration' do
    it 'returns the correct ride duration' do
      allow(ride).to receive(:get_directions).with(ride.start_address, ride.destination_address, driver)
        .and_return({'duration' => {'value' => 2700}})
      expect(ride.ride_duration(driver)).to eq(0.75)
    end
  end

  describe '#get_directions' do
    it 'returns the correct directions for a given origin and destination' do
      allow(HTTParty).to receive(:get)
        .and_return({"routes"=>[{"legs"=>[{"distance"=>{"value"=>16093}, "duration"=>{"value"=>2700}}]}]})
      expect(ride.send(:get_directions, ride.start_address, ride.destination_address, driver))
        .to eq({"distance"=>{"value"=>16093}, "duration"=>{"value"=>2700}})
    end
  end
end