FactoryGirl.define do
  factory :order do
    user
    after(:create) {|order| order.line_items << FactoryGirl.create(:line_item) }
  end
end
