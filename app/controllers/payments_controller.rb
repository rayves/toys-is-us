class PaymentsController < ApplicationController
  # need to skip auth as the request is coming from stripe api, an outside source
  skip_before_action :verify_authenticity_token, only: [:webhook]
  def success
    @order = Order.find_by(listing_id: params[:id])
  end

# when checkout_session_complete, stripe posts to webhook
  def webhook
    # check with stripe signing secret matches webhook.
      # create event
        # payload = body of request (all the data that comes from the request = params) - Stripe is sending a post request
        # header
        # endpoint_secret
    begin          
      # assign the body of the webhook params has payload
    payload = request.raw_post
      # assign stripe header (signature) - check if header has stripe signiture
    header = request.headers["HTTP_STRIPE_SIGNATURE"]
    secret = Rails.application.credentials.dig(:stripe, :webhook_signature)
      # check stripe header matches webhook signature in credentials -> if so save event as 'event' variable
    event = Stripe::Webhook.construct_event(payload, header, secret)
    rescue Stripe::SignatureVerificationError => e
      # error when Stripe tries to check signature -> if invalid signature then error is raised and this error is rescued here. Return ending post request before any other line is executed
      render json: {error: "Unauthorised"}, status: 403
      return
    rescue JSON::ParserError => e
      # rescue if issue with request, return ending post request before any other line is executed
      render json: {error: "Bad Request"}, status: 422
      return
    end

    puts "****************"
    pp event
    puts "****************"

    # payment_intent_id = params[:data][:object][:payment_intent]
    payment_intent_id = event.data.object.payment_intent
    payment = Stripe::PaymentIntent.retrieve(payment_intent_id)
    listing_id = payment.metadata.listing_id
    buyer_id = payment.metadata.user_id
    receipt = payment.charges.data[0].receipt_url
    @listing = Listing.find(listing_id)
    @listing.update(sold: true)
    # Create order/purchase and track extra info
    Order.create(listing_id: listing_id, seller_id: @listing.user_id, buyer_id: buyer_id, payment_id: payment_intent_id, receipt_url: receipt)
  end

end
