FactoryBot.define do
  factory :order do
    listing { nil }
    buyer { nil }
    seller { nil }
    payment_id { "MyString" }
    receipt_url { "MyString" }
  end
end
