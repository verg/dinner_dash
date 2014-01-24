require 'spec_helper'

describe Cart do

  it { should have_many(:line_items).dependent(:destroy) }
  it { should belong_to(:user) }

  describe ".add_product" do
    it "adds a line item to the cart for the product" do
      cart = Cart.create
      product = create(:product)
      cart.add_product(product)
      expect(cart.line_items.first.product_id).to eq product.id
    end
  end

  describe "#total_price" do
    it "sums the total prices for each of its line items" do
      cart = Cart.create
      food = create(:product, price_cents: 350)
      drink = create(:product, price_cents: 150)
      cart.add_product(food)
      cart.add_product(drink)

      expect(cart.total_price).to eq Money.new(350+150, "USD")
    end
  end

  describe "#count" do
    it "returns the number of line_items in the cart" do
      cart = Cart.create
      food = create(:product, price_cents: 350)
      drink = create(:product, price_cents: 150)
      cart.add_product(food)
      cart.add_product(drink)
      cart.add_product(drink)

      expect(cart.count).to eq 3
    end
  end

  describe "#increment_quantity_or_create_line_item_by_product_id" do

    let(:product_id) { 1 }
    context "a line item exists for that cart and product" do
      it "increments a line item's quantity" do
        cart = Cart.create
        cart.line_items << create(:line_item, product_id: 1, quantity: 1)

        item = cart.increment_quantity_or_create_line_item_by_product_id(product_id, 2)
        expect(item.quantity).to eq 1 + 2
      end
    end

    context "a line item doesn't exist" do
      it "creates a new line item with the specified quantity and product id" do
        cart = Cart.create

        item = nil # initialize var so we can access outside of expect block

        expect {
          item = cart.increment_quantity_or_create_line_item_by_product_id(product_id, 2)
        }.to change(LineItem, :count).by(1)
        expect(item.quantity).to eq 2
      end
    end
  end
end
