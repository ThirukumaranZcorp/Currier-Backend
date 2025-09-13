class Api::V1::CourierRecommendationsController < ApplicationController
    before_action :authenticate_user!

    # def index
    # couriers = Courier.all
    # recommendations = couriers.map do |courier|
    #     {
    #     name: courier.name,
    #     service_type: courier.service_type,
    #     estimated_price: calculate_price(courier),
    #     eta: rand(1..3).to_s + " hrs"
    #     }
    # end

    # render json: recommendations
    # end

    # private

    # def calculate_price(order)
    #     distance = Geocoder::Calculations.distance_between(
    #         [order.pickup_lat, order.pickup_lng],
    #         [order.dropoff_lat, order.dropoff_lng]
    #     ) # returns distance in miles by default

    #     distance_km = distance * 1.60934 # convert to KM
    #     base_price = 50
    #     per_km_price = 5
    #     weight_charge = order.package_weight.to_f * 2

    #     base_price + (distance_km * per_km_price) + weight_charge
    # end

    # before_action :authenticate_user!

    def index
        pickup_lat = params[:pickup_lat].to_f
        pickup_lng = params[:pickup_lng].to_f
        dropoff_lat = params[:dropoff_lat].to_f
        dropoff_lng = params[:dropoff_lng].to_f
        package_weight = params[:package_weight].to_f
        p pickup_lat, pickup_lng, dropoff_lat, dropoff_lng, package_weight
        couriers = Courier.all
        recommendations = couriers.map do |courier|
            distance_km = Geocoder::Calculations.distance_between(
            [pickup_lat, pickup_lng],
            [dropoff_lat, dropoff_lng]
            ) * 1.60934 rescue 10

            price = courier.base_price + (distance_km * courier.price_per_km) + (package_weight * 2)

            {
            id: courier.id,
            name: courier.name,
            service_type: courier.service_type,
            estimated_price: price.round(2),
            eta: "#{rand(1..3)} hrs"
            }
        end

        render json: recommendations
    end


end
