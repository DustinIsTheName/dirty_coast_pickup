class PickupMailer < ApplicationMailer
  default from: 'contact@dirtycoast.com'

  def checkout(params)
    @line_items = params["line_items"]

    @shipping_or_pickup = params["shipping_or_pickup"]
    @pickup_address = params["pickup_address"]

    @name = params["name"]
    @email = params["email"]

    if Rails.env.development? or ENV["TESTING"] == 'testing'
      if ENV["TESTING"] == 'testing'
        address = ENV["TESTING_ADDRESS"] ? ENV["TESTING_ADDRESS"] : "dustin@wittycreative.com"
        from = ENV["TESTING_FROM"] ? ENV["TESTING_FROM"] : "dustin@wittycreative.com"
        reply_to = @email
      else
        address = "dustin@wittycreative.com"
        from = "dustin@wittycreative.com"
        reply_to = @email
      end
      # address = 'test@blackhole.postmarkapp.com'
    else
      address = ENV["ADDRESS"] ? ENV["ADDRESS"] : "shipping@dirtycoast.com"
      from = ENV["FROM"] ? ENV["FROM"] : "contact@dirtycoast.com"
      reply_to = @email
    end

    mail(to: address, reply_to: reply_to, from: from, subject: "Checkout created")
  end

  def test
    mail(
      subject: 'Hello from Postmark',
      to: "dustin@wittycreative.com",
      from: 'dustin@wittycreative.com',
      html_body: '<strong>Hello</strong> dear Postmark user.',
      message_stream: 'outbound')
  end

end