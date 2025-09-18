class DeliveryTrackingChannel < ApplicationCable::Channel
  def subscribed
      # A client subscribes to a specific order
      order_id = params[:order_id]
      stream_from "delivery_tracking_#{order_id}"
  end

  def unsubscribed
    # Cleanup if needed
  end
  
end
