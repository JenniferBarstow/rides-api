require 'rails_helper'

RSpec.describe Driver, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:home_address) }
  end
end