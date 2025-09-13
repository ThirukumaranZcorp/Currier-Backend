class Api::V1::CouriersController < ApplicationController
    before_action :authenticate_user!
    before_action :set_courier, only: [:show, :update, :destroy]

      # GET /api/v1/couriers
      def index
        render json: Courier.all
      end

      # GET /api/v1/couriers/:id
      def show
        render json: @courier
      end

      # POST /api/v1/couriers
      def create
        courier = Courier.new(courier_params)
        if courier.save
          render json: { message: "Courier created successfully", courier: courier }, status: :created
        else
          render json: { errors: courier.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/couriers/:id
      def update
        if @courier.update(courier_params)
          render json: { message: "Courier updated successfully", courier: @courier }
        else
          render json: { errors: @courier.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/couriers/:id
      def destroy
        @courier.destroy
        render json: { message: "Courier deleted successfully" }
      end

      private

      def set_courier
        @courier = Courier.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Courier not found" }, status: :not_found
      end

      def courier_params
        params.require(:courier).permit(:name, :service_type, :base_price, :price_per_km)
      end
end
