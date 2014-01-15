FactoryGirl.define do
  factory :product do
    title "Mapo Tofu"
    description "delicious"
    price_cents 895
    after(:create) {|product| product.categories << FactoryGirl.create(:category) }
  end
end
