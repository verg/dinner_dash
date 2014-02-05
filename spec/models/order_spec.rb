require 'spec_helper'

describe Order do
  it { should belong_to(:user) }
  it { should have_many(:line_items) }
  it { should have_one(:transaction) }

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

  it "has a name and email for the user" do
    user = create(:user)

    order = create(:order, user: user)

    expect(order.user_name).to eq user.full_name
    expect(order.user_email).to eq user.email
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

  describe "#finalized_at" do
    it "is set when the order's cancel or complete status is updated" do
      order = create(:order, canceled: false)
      expect {
        order.update_attributes(canceled: true)
        order.save
      }.to change(order, :finalized_at)

      order = create(:order, complete: false)
      expect {
        order.update_attributes(complete: true)
        order.save
      }.to change(order, :finalized_at)

      expect(create(:order, complete: true).finalized_at).not_to be_false
      expect(create(:order, canceled: true).finalized_at).not_to be_false
    end

    it "doesn't update if the order is updated w/ the same canceled & complete status" do
      order = create(:order, canceled: true)
      expect {
        order.update_attributes(canceled: true)
        order.save
      }.not_to change(order, :finalized_at)

      order = create(:order, complete: true)
      expect {
        order.update_attributes(complete: true)
        order.save
      }.not_to change(order, :finalized_at)
    end

    describe ".query_by_status" do
      it "returns records based on their status" do
        canceled = create(:order, canceled: true, complete: true, paid: true)
        complete = create(:order, complete: true, paid: true)
        paid = create(:order, paid: true)
        ordered = create(:order)

        expect(Order.query_by_status(:canceled)).to eq [canceled]
        expect(Order.query_by_status(:complete)).to eq [complete]
        expect(Order.query_by_status(:paid)).to eq [paid]
        expect(Order.query_by_status(:ordered)).to eq [ordered]
      end
    end
  end
end
