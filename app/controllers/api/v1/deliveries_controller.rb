class Api::V1::DeliveriesController < ApplicationController
    before_action :authenticate_user!

    before_action :set_order, only: [:update]

    # def create
    #     order = current_user.orders.new(order_params)
    #     order.price = format('%.2f', calculate_price(order))

    #     if order.save
    #         render json: {
    #         status: "success",  # ✅ custom string
    #         message: "Delivery scheduled successfully",
    #         order: order
    #         }, status: :ok # ✅ HTTP 200
    #     else
    #         render json: {
    #         status: "error", # ✅ custom string
    #         errors: order.errors.full_messages
    #         }, status: :unprocessable_entity
    #     end
    # end

    def create
        order = current_user.orders.new(order_params)
        order.price = calculate_price(order).round(2)

        if order.save
            render json: {
            status: "success",
            message: "Delivery scheduled successfully",
            order: {
                id: order.id,
                pickup_address: order.pickup_address,
                dropoff_address: order.dropoff_address,
                service_type: order.courier&.name, # Assuming courier has a name column
                # service_type: order.courier&.service_type,
                final_price: sprintf('%.2f', order.price),
                # status: order.status
            }
            }, status: :ok
        else
            render json: {
            status: "error", # ✅ custom string
            errors: order.errors.full_messages
            }, status: :unprocessable_entity
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


    def update
        if @order.update(order_params)
            render json: { message: "Order status updated", status: @order.status }
        else
            render json: { errors: @order.errors.full_messages }, status: :unprocessable_entity
        end
    end



    private

    def set_order
        @order = Order.find(params[:id])
    rescue ActiveRecord::RecordNotFound
        render json: { error: "Order not found" }, status: :not_found
    end

    def order_params
    params.require(:order).permit( :pickup_address,:pickup_lat,:pickup_lng , :dropoff_address,:dropoff_lat ,:dropoff_lng , :package_size, :package_weight , :status , :courier_id)
    end

    def calculate_price(order)
        courier = Courier.find(order.courier_id)
        courier.estimate_cost.to_f.round(2)
        # distance = Geocoder::Calculations.distance_between(
        #     order.pickup_address, order.dropoff_address
        # ) rescue 10 # fallback 10 km if geocoding fails

        # base_price = 50 # flat base price
        # per_km_price = 5 # Rs. per km
        # weight_charge = order.package_weight.to_f * 2

        # base_price + (distance * per_km_price) + weight_charge
    end

end
