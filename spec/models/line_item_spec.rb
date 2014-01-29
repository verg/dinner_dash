require 'spec_helper'

describe LineItem do
  it { should belong_to(:cart) }
  it { should belong_to(:product) }
  it { should belong_to(:order) }
  it { should_not allow_value(-1).for(:quantity) }

  it "has a product_title" do
    line_item = create(:line_item)
    expect(line_item.product_title).to eq line_item.product.title
  end

  it "has a product_description" do
    line_item = create(:line_item)
    expect(line_item.product_description).to eq line_item.product.description
  end

  it "has a total_price" do
    product = build_stubbed(:product, price_cents: 899, title: "Foodstuff")
    line_item = build_stubbed(:line_item, product: product, quantity: 2)
    expect(line_item.total_price).to eq Money.new(899*2, "USD")
  end

  describe "#increment_quantity" do
    it 'increments the quanity' do
      line_item = create(:line_item)
      quantity = line_item.quantity
      line_item.increment_quantity
      expect(line_item.quantity).to eq quantity + 1
    end
  end
end
