class Api::V1::DeliveryLocationsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_order, only: [:update,:show]

    # Delivery Boy updates current location
    def update
        # authorize_delivery_boy!
        puts "--------------------------------------comming here---------------------------------------"
        # @order = Order.find(params[:delivery_id])
        # puts "-------------------------------------------------------------"
        # puts @order.inspect
        # puts "-----------------------end--------------------------------------"
        location = @order.delivery_location || @order.build_delivery_location
        if location.update(location_params)
            render json: { message: "Location updated", location: location }, status: :ok
        else
            render json: { errors: location.errors.full_messages }, status: :unprocessable_entity
        end
    end

    # Users get the latest live location
    def show
        if @order.delivery_location
            render json: {
            order_id: @order.id,
            status: @order.status,
            current_location: {
                lat: @order.delivery_location.current_lat,
                lng: @order.delivery_location.current_lng
            },
            eta: @order.estimated_eta
            }
        else
            render json: { message: "No live location available yet" }, status: :not_found
        end
    end







    private

    def set_order
        @order = Order.find(params[:delivery_id])
    end

    def location_params
    params.require(:delivery_location).permit(:current_lat, :current_lng)
    end

    def authorize_delivery_boy!
    unless current_user.role == "delivery_boy"
        render json: { error: "Only delivery boy can update location" }, status: :forbidden
    end
    end
end
