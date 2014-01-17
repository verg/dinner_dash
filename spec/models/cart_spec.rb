require 'spec_helper'

describe Cart do
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
end
