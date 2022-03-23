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
end
