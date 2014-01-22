require 'spec_helper'

describe LineItem do
  it { should belong_to(:cart) }
  it { should belong_to(:product) }

  it "has a product_title" do
    line_item = create(:line_item)
    expect(line_item.product_title).to eq line_item.product.title
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
