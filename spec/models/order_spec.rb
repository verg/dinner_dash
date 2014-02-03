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

  describe "#total_price" do
    it "sums the total prices for each of its line items" do
      food = build(:product, price_cents: 350)
      drink = build(:product, price_cents: 150)
      line_items = [build(:line_item, product: food), build(:line_item, product: drink)]
      order = Order.create
      order.line_items << line_items

      expect(order.total_price).to eq Money.new(350+150, "USD")
    end
  end

  describe ".for_user" do
    it "finds all orders for the specified user" do
      user = create(:user)
      other_user = create(:user)

      users_order = create(:order, user: user)
      other_users_order = create(:order, user: other_users_order)

      expect( Order.for_user(user) ).to include(users_order)
      expect( Order.for_user(user) ).not_to include(other_users_order)
    end
  end

  describe "order status" do
    it "has status helpers" do
      order = create(:order, complete: true, paid: true, canceled: true)
      expect(order.completed?).to be_true
      expect(order.paid?).to be_true
      expect(order.canceled?).to be_true

      order = create(:order, complete: false, paid: false, canceled: false)
      expect(order.paid?).to be_false
      expect(order.completed?).to be_false
      expect(order.canceled?).to be_false
    end
  end
end
