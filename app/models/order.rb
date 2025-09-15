require "geocoder"
class Order < ApplicationRecord
    belongs_to :user
    belongs_to :courier, optional: true 
    has_one :delivery_location, dependent: :destroy
    enum :status, {
      created: 0,
      scheduled: 1,
      picked_up: 2,
      in_transit: 3,
      delivered: 4,
      cancelled: 5
    }
  # Estimate ETA (very simple calculation for demo)
  # def estimated_eta
  #   # Assume courier speed = 40 km/h
  #   distance_km = Geocoder::Calculations.distance_between([pickup_lat, pickup_lng], [dropoff_lat, dropoff_lng])
  #   hours = distance_km / 40.0
  #   (hours * 60).round # return ETA in minutes
  # end


  def estimated_eta
    distance_km = Geocoder::Calculations.distance_between(
      [pickup_lat, pickup_lng],
      [dropoff_lat, dropoff_lng]
    )
    Rails.logger.info "DEBUG: Distance = #{distance_km} km"
    hours = distance_km / 40.0
    (hours * 60).round
  end




  validates :pickup_address,:pickup_lat,:pickup_lng , :dropoff_address,:dropoff_lat , :dropoff_lng , :package_size, :package_weight , presence: true
end
