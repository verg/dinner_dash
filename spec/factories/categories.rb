FactoryGirl.define do
  factory :category do
    name "entrees"

    factory :invalid_category do
      name nil
    end
  end
end
