FactoryGirl.define do
  factory :order do
    line_item
    user
    status "ordered"
  end
end
