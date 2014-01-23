require 'spec_helper'

describe Cart do

  it { should have_many(:line_items) }
  it { should belong_to(:user).dependent(:destroy) }

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
end
