class ListingsController < ApplicationController
  # before execution any action authenticate users except on the specified actions
  before_action :authenticate_user!, except: [:index, :show] #=> checks is there a user logged in, if not redirect to sign in page
  before_action :set_listing, only: [:show, :edit, :update, :destroy] #=> set instance variable @listing so actions can access all listings variable
  before_action :authorize_user, only: [:edit, :update, :destroy] #=> check if the listing's user id equals the current user id. If not flash alert and redirect.
  before_action :set_form_vars, only: [:new, :edit]
  def index
    @listings = Listing.all
  end

  def show
    #create session -> use Stripe gem -> use Checkout function -> use session function with Checkout function
    session = Stripe::Checkout::Session.create(
      payment_method_types: ['card'],
      customer_email: current_user && current_user.email, #=> requires user be logged in
      line_items: [
        {
          name: @listing.title,
          description: @listing.description,
          amount: @listing.price,
          currency: 'aud',
          quantity: 1
        }
      ],
      payment_intent_data: {
        metadata: {
          # this sends the below data to stripe and when data is retrieved, a row can be created in the database to track this. i.e. that the customer has made a payment and what they've bought.
          user_id: current_user && current_user.id,
          listing_id: @listing.id
        }
      },
      # as there is a redirection to Stripe's website and then a redirection back after processing of payment. URLs can be added for re-direction.
      success_url: "#{root_url}payments/success/#{@listing.id}",
      cancel_url: root_url
    )

    # 'session' object has an id when created. So this can be saved by instance varaible for wider access.
    @session_id = session.id
  end

  def new
    # so that there is a partial to pick up errors. There won't be errors on an empty listing
    @listing = Listing.new
  end

  def create
    # # possible passing of user id when creation of new listing. Same thing must be done for update
    # @listing = Listing.new(category_id: params[:category_id])
    # @listing = Listing.new(listing_params)
    # As user has many listings, create new listing by accessing the Current_users listings
    @listing = current_user.listings.new(listing_params)
    if @listing.save
        redirect_to @listing, notice: "Listing successfully created"
    else
      set_form_vars
      render "new", alert: "Something went wrong"
    end
  end

  def edit

  end

  def update
    @listing.update(listing_params)
    if @listing.save
        redirect_to @listing, notice: "Listing successfully updated"
    else
      set_form_vars
      render "edit", alert: "Something went wrong"
    end
  end

  def destroy
      @listing.destroy
      redirect_to listings_path, notice: "Listing Sucessfully Deleted"
  end

  private

  def listing_params
    params.require(:listing).permit(:title, :price, :category_id, :condition, :description, :picture, feature_ids: [])
      # feature_ids: [] -> must have default value of empty array and speifies that it is an array
  end

  def authorize_user
    if @listing.user_id != current_user.id
      # flash[:alert] = "You don't have permission to do that"
      redirect_to listing_path, alert: "You don't have permission to do that"
    end
  end
  

  def set_listing
    @listing = Listing.find(params[:id])
  end

  def set_form_vars
    @categories = Category.all
    @conditions = Listing.conditions.keys
    @features = Feature.all
  end

end
