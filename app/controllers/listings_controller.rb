class ListingsController < ApplicationController
  # before execution any action authenticate users except on the specified actions
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_listing, only: [:show, :edit, :update, :destroy]
  before_action :set_form_vars, only: [:new, :edit]
  def index
    @listings = Listing.all
  end

  def show

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
  end

  private

  def listing_params
    params.require(:listing).permit(:title, :price, :category_id, :condition, :description, :picture)
  end

  def set_listing
    @listing = Listing.find(params[:id])
  end

  def set_form_vars
    @categories = Category.all
    @conditions = Listing.conditions.keys
  end

end
