require 'spec_helper'

describe Cart do
  before(:each) do
    Bullet.start_request if Bullet.enable?
  end

  after(:each) do
    Bullet.perform_out_of_channel_notifications if Bullet.enable? && Bullet.notification?
    Bullet.end_request if Bullet.enable?
  end

  it { should have_many(:line_items) }
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
end
