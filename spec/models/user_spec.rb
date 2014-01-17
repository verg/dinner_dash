require 'spec_helper'

describe User do
  it { should have_one(:cart) }

  describe ".items_in_cart" do
    it "returns line items in a user's cart" do
      user = User.create
      in_cart = create(:line_item, cart: user.build_cart)
      not_in_cart = create(:line_item)
      expect(user.items_in_cart).to eq [in_cart]
    end
  end
end
