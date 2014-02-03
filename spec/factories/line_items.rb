FactoryGirl.define do
  factory :line_item do
    quantity 1
    product

    factory :invalid_line_item do
      quantity(-1)
    end
  end
end
