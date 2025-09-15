class DeliveryLocation < ApplicationRecord
    belongs_to :order
    validates :current_lat, :current_lng, presence: true
end
