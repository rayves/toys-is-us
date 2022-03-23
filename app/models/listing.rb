class Listing < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_many :listings_features, dependent: :destroy
    # dependent: :destroy -> if listing is deleted then listings_feature related to that listing is deleted
  has_many :features, through: :listings_features



  # conditions very loved, gently used, well looked after, brand new
  # enum condition: {"very loved" => 1, "gently used" => 2, "well looked after" => 3, "brand new" => 4}
  enum condition: {very_loved: 1, loved: 2, well_looked_after: 3, brand_new: 4}
  has_one_attached :picture

  #validation
    # ensure specified columns are present. If not then listng is not valid. Therefore will not save to database.
  validates :title, :description, :price, :condition, presence: true
  validates :title, length: {minimum: 4}

  # Sanitise data with lifecycle hooks
  before_save :remove_whitespace, :remove_covid
  before_validation :convert_price_to_cents, if: :price_changed?
    # if: :price_changed? -> required as otherwise price will continously be multiplied by 100 every time price is loaded in when updating listing.

  private

  def remove_whitespace
    self.title = self.title.strip
    self.description = self.description.strip
  end

  def remove_covid
      # where is title appears covid sub with pfizer
      # /covid/i case insensitive covid
        # i -> case insensitive
    self.title = self.title.gsub(/covid/i, "pfizer")
    self.description = self.description.gsub(/covid/i, "pfizer")
  end

  def convert_price_to_cents
    # grab attribute before changed into integer
      # .attributes_before_type_cast -> before conversion into an integer grab the raw data key price from this hash.
      # all attributes come into forms as string then are converted into column value
    self.price = (self.attributes_before_type_cast["price"].to_f * 100).round
  end
end
