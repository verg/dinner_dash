require 'spec_helper'

describe User do
  it { should have_one(:cart) }
  it { should have_many(:line_items) }
  it { should have_many(:orders) }

  describe ".items_in_cart" do
    it "returns line items in a user's cart" do
      user = create(:user)
      in_cart = create(:line_item, cart: user.create_cart)
      not_in_cart = create(:line_item)

      expect(user.items_in_cart).to eq [in_cart]
    end

    it "has a full name" do
      user = create(:user)
      expect(user.full_name).to eq user.firstname + " " + user.lastname
    end
  end
end
