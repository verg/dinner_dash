require 'spec_helper'

describe User do
  it { should have_one(:cart) }
  it { should have_many(:line_items) }

  describe ".items_in_cart" do
    it "returns line items in a user's cart" do
      user = create(:user)
      in_cart = create(:line_item, cart: user.create_cart)
      not_in_cart = create(:line_item)

      expect(user.items_in_cart).to eq [in_cart]
    end
  end
end
