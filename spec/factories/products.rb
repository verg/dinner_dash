require 'faker'

FactoryGirl.define do
  factory :product do
    title { Faker::Lorem.sentence(2) }
    description "A delicious treat."
    price_cents 895
    after(:create) {|product| product.categories << FactoryGirl.create(:category) }
    factory :invalid_product do
      title nil
    end
  end
end
