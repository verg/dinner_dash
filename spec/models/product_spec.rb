require 'spec_helper'

describe Product do

  it { should have_many(:categories) }
  it { should have_many(:line_items) }

  it "has a valid factory" do
    expect(FactoryGirl.build(:product)).to be_valid
  end

  it "has availible products" do
    product = create(:product)
    expect(Product.available).to include product
  end

  describe "title" do
    it "must be present" do
      expect(Product.new(title: "")).to have(1).errors_on(:title)
      expect(Product.new).to have(1).errors_on(:title)
    end

    it "must be unique" do
      create(:product, title: "not_uniq")
      expect(build(:product, title: "not_uniq")).to have(1).errors_on(:title)
    end
  end

  describe "price_cents" do
    it 'must be greater than zero' do
      expect(build(:product, price_cents: -1)).to have(1).errors_on(:price_cents)
    end

    it "must be an integer" do
      expect(build(:product, price_cents: 0.1)).to have(1).errors_on(:price_cents)
    end
  end

  describe "photo" do
    it { should validate_attachment_content_type(:photo).
         allowing('image/png', 'image/jpg', 'image/gif') }
  end
end
