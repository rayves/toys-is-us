class PaymentsController < ApplicationController
  # need to skip auth as the request is coming from stripe api, an outside source
  skip_before_action :verify_authenticity_token, only: [:webhook]
  def success
    @listing = Listing.find(params[:id])
    # @listing.sold = true
  end

  def webhook
    # check with stripe signing secret matches webhook.
      # create event
        # payload = body of request (all the data that comes from the request = params) - Stripe is sending a post request
        # header
        # endpoint_secret
    begin          
    payload = request.raw_post
    header = request.headers["HTTP_STRIPE_SIGNATURE"]
    secret = Rails.application.credentials.dig(:stripe, :webhook_signature)
    event = Stripe::Webhook.construct_event(payload, header, secret)
    rescue Stripe::SignatureVerificationError => e
      # error when Stripe tries to check signature -> if invalid signature then error is raised and this error is rescued here.
      render json: {error: "Unauthorised"}, status: 403
      return
    rescue JSON::ParserError => e
      render json: {error: "Bad Request"}, status: 422
      return
    end

    # payment_intent_id = params[:data][:object][:payment_intent]
    payment_intent_id = event.data.object.payment_intent
    payment = Stripe::PaymentIntent.retrieve(payment_intent_id)
    listing_id = payment.metadata.listing_id
    pp payment.charges.data[0].receipt_url
    @listing = Listing.find(listing_id)
    @listing.update(sold: true)
  end

end
