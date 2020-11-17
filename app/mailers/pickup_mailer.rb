class PickupMailer < ApplicationMailer

  def checkout(params)
    @line_items = params["line_items"]

    @shipping_or_pickup = params["shipping_or_pickup"]
    @pickup_address = params["pickup_address"]

    if Rails.env.development? or ENV["TESTING"] == 'testing'
      address = "dustin@wittycreative.com"
    else
      address = "shipping@dirtycoast.com"
    end

    mail(to: address, subject: "Checkout created")
  end

end