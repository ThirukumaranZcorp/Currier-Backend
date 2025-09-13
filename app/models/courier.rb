class Courier < ApplicationRecord
    has_many :orders
    validates :name, :service_type, :base_price, :price_per_km, presence: true
end
