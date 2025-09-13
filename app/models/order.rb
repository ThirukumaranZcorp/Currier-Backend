class Order < ApplicationRecord
    belongs_to :user
    belongs_to :courier, optional: true 

#   enum status: {
#     created: 0,
#     scheduled: 1,
#     picked_up: 2,
#     in_transit: 3,
#     delivered: 4,
#     cancelled: 5
#   }

  validates :pickup_address,:pickup_lat,:pickup_lng , :dropoff_address,:dropoff_lat , :dropoff_lng , :package_size, :package_weight , presence: true
end
