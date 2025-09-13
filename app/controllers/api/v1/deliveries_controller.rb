class Api::V1::DeliveriesController < ApplicationController
    before_action :authenticate_user!

    def create
        order = current_user.orders.new(order_params)
        order.price = calculate_price(order)

        if order.save
            render json: { message: "Delivery scheduled", order: order }, status: :created
        else
            render json: { errors: order.errors.full_messages }, status: :unprocessable_entity
        end
    end

    # def create
    #     order = current_user.orders.new(order_params)
    #     order.courier = Courier.first # or pick cheapest/fastest by default
    #     order.price = calculate_price(order)

    #     if order.save
    #         render json: { message: "Delivery scheduled", order: order }, status: :created
    #     else
    #         render json: { errors: order.errors.full_messages }, status: :unprocessable_entity
    #     end
    # end


    def assign_courier
        order = current_user.orders.find(params[:id])
        courier = Courier.find(params[:courier_id])

        order.update!(courier: courier, status: :scheduled)

        render json: { message: "Courier assigned successfully", order: order }
    end


    private

    def order_params
    params.require(:order).permit(:pickup_address,:pickup_lat,:pickup_lng , :dropoff_address,:dropoff_lat ,:dropoff_lng , :package_size, :package_weight )
    end

    def calculate_price(order)
        distance = Geocoder::Calculations.distance_between(
            order.pickup_address, order.dropoff_address
        ) rescue 10 # fallback 10 km if geocoding fails

        base_price = 50 # flat base price
        per_km_price = 5 # Rs. per km
        weight_charge = order.package_weight.to_f * 2

        base_price + (distance * per_km_price) + weight_charge
    end

end
