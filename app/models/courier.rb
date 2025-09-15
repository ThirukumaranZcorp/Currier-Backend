class Courier < ApplicationRecord
    has_many :orders
    validates :name, :estimate_time, :estimate_cost, :service_type, presence: true
end
