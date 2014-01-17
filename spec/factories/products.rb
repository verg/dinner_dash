require 'faker'

FactoryGirl.define do
  factory :product do
    title { Faker::Lorem.sentence(2) }
    description "delicious"
    price_cents 895
    after(:create) {|product| product.categories << FactoryGirl.create(:category) }
  end
end
