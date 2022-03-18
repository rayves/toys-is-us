FactoryBot.define do
  factory :listing do
    title { "MyString" }
    condition { 1 }
    price { 1 }
    sold { false }
    description { "MyText" }
    user { nil }
    category { nil }
  end
end
