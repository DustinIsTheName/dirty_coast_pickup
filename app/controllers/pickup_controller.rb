class PickupController < ApplicationController

  skip_before_action :verify_authenticity_token, :only => [:checkout, :order_webhook]
  before_action :set_headers

  def checkout
    puts params

    PickupMailer.checkout(params).deliver

    render json: params
  end

  def order_webhook
    begin
      order = ShopifyAPI::Order.find params["id"]
      puts params

      shipping_or_pickup = params["note_attributes"].select{|a| a["name"] == "shipping_or_pickup"}.first
      pickup_address = params["note_attributes"].select{|a| a["name"] == "pickup_address"}.first

      if shipping_or_pickup
        if shipping_or_pickup["value"] == "Local Pickup"
          puts Colorize.green("added Local Pickup tag")
          order.tags = "Local Pickup"
          if pickup_address
            order.tags << ", #{pickup_address["value"]}"
            case pickup_address["value"]
            when "5631 Magazine St."
              order.tags << ", uptown"
            when "1320 Magazine St."
              order.tags << ", lowergarden"
            when "713 Royal St."
              order.tags << ", frenchquarter"
            end
          end
        else
          puts Colorize.cyan("Not a Local Pickup")
        end
        if order.save
          puts Colorize.green "order saved"
        else
          puts Colorize.red "#{order.errors.messages}"
        end
      else
        puts Colorize.cyan("Not a Local Pickup")
      end
    rescue
      puts Colorize.red("Product Not Found")
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