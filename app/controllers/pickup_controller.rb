class PickupController < ApplicationController

  skip_before_action :verify_authenticity_token, :only => [:checkout, :order_webhook]
  before_action :set_headers

  def checkout
    puts params

    PickupMailer.checkout(params).deliver

    render json: params
  end

  def order_webhook
    order = ShopifyAPI::Order.find params["id"]
    puts params

    shipping_or_pickup = params["note_attributes"].select{|a| a["name"] == "shipping_or_pickup"}.first
    pickup_address = params["note_attributes"].select{|a| a["name"] == "pickup_address"}.first

    if shipping_or_pickup
      if shipping_or_pickup["value"] == "Local Pickup"
        order.tags = "pickup-order"
        if pickup_address
          order.tags << ", #{pickup_address["value"]}"
        end
      end
      order.save
    end

    head :ok, content_type: "text/html"
  end

  def test
    render json: {test: true}
  end

  private

    def set_headers
      headers['Access-Control-Allow-Origin'] = '*'
      headers['Access-Control-Request-Method'] = '*'
    end

end