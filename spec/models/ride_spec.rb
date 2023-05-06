require 'rails_helper'

RSpec.describe Ride, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:start_address) }
    it { should validate_presence_of(:destination_address) }
  end
end