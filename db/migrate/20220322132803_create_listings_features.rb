class CreateListingsFeatures < ActiveRecord::Migration[7.0]
  def change
    create_table :listings_features do |t|
      t.references :listing, null: false, foreign_key: true
      t.references :feature, null: false, foreign_key: true

      t.timestamps
    end
  end
end
