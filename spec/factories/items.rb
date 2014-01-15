FactoryGirl.define do
  factory :item do
    title "Mapo Tofu"
    description "delicious"
    price_cents 895
    after(:create) {|item| item.categories << FactoryGirl.create(:category) }
  end
end
