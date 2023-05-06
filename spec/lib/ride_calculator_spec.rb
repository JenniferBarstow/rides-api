require 'ride_calculator'

describe RideCalculator do
  let(:ride) { instance_double('Ride', start_address: '123 Main St.', destination_address: '456 Elm St.') }
  let(:driver) { instance_double('Driver', home_address: '789 Oak St.') }
  let(:directions_service) { instance_double('DirectionsService') }
  let(:ride_calculator) { RideCalculator.new(ride, driver) }

  before do
    allow(DirectionsService).to receive(:new).and_return(directions_service)
  end

  describe '#score' do
    it 'returns the score of the ride' do
      allow(directions_service).to receive(:get_directions).and_return(
        { 'distance' => { 'value' => 16093 }, 'duration' => { 'value' => 2700} }
      )
      allow(ride_calculator).to receive(:ride_earnings).and_return(20)
      allow(ride_calculator).to receive(:commute_duration).and_return(5)
      allow(ride_calculator).to receive(:ride_duration).and_return(5)
      expect(ride_calculator.score).to eq(2)
    end
  end

  describe '#ride_earnings' do
    it 'returns the earnings of the ride' do
      allow(directions_service).to receive(:get_directions).and_return(
        { 'distance' => { 'value' => 16093 }, 'duration' => { 'value' => 2700} }
      )
      allow(ride_calculator).to receive(:ride_distance).and_return(10)
      allow(ride_calculator).to receive(:ride_duration).and_return(20)
      expect(ride_calculator.ride_earnings).to eq(23)
    end
  end

  describe '#commute_distance' do
    it 'returns the distance of the drivers commute to the ride start address' do
      allow(directions_service).to receive(:get_directions).and_return(
        {'distance' => {'value' => 80467}}
      )
      expect(ride_calculator.commute_distance).to eq(49.99987572576155)
    end
  end

  describe '#commute_duration' do
    it 'returns the duration of the drivers commute to the ride start address' do
      allow(directions_service).to receive(:get_directions).and_return(
        {'duration' => {'value' => 5400}}
      )
      expect(ride_calculator.commute_duration).to eq(1.5)
    end
  end

  describe '#ride_distance' do
    it 'returns the distance of the ride' do
      allow(directions_service).to receive(:get_directions)
      .and_return({'distance' => {'value' => 16093}})
      expect(ride_calculator.ride_distance).to eq(9.999726596675416)
    end
  end

  describe '#ride_duration' do
    it 'returns the duration of the ride' do
      allow(directions_service).to receive(:get_directions)
      .and_return({'duration' => {'value' => 2700}})
      expect(ride_calculator.ride_duration).to eq(0.75)
    end
  end
end
