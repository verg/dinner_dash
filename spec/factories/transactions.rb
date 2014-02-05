FactoryGirl.define do
  factory :transaction do
    type "Stripe"
    external_id "xyz"
    last_four "4222"
    card_type "MasterCard"
  end
end
