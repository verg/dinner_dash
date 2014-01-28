require 'spec_helper'

describe Order do
  it { should belong_to(:user) }
  it { should have_many(:line_items) }

  describe ".create_from_cart" do
    let(:food) { create(:product, price_cents: 350) }
    let(:drink) { create(:product, price_cents: 150) }

    it "does something" do
      cart = Cart.create(user: create(:user))

      food_line_item = cart.add_product(food)
      drink_line_item = cart.add_product(drink)

      order = Order.create_from_cart(cart)
      expect(order).to be_valid
      expect(order.line_items).to include(food_line_item, drink_line_item)
    end
  end
end
