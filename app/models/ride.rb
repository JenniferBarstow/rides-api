class Ride < ApplicationRecord
  belongs_to :driver, optional: true
  validates_presence_of :start_address, :destination_address
end
