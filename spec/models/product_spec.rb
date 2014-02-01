require 'spec_helper'

describe Product do

  it { should have_many(:categories) }
  it { should have_many(:line_items) }

  it "has a valid factory" do
    expect(FactoryGirl.build(:product)).to be_valid
  end

  it "has available and retired products" do
    available = create(:product, available: true)
    retired = create(:product, available: false)

    expect(Product.available).to include available
    expect(Product.available).not_to include retired

    expect(Product.retired).to include retired
    expect(Product.retired).not_to include available
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

  describe "available" do
    it "must be present" do
      product = build(:product, available: nil)
      expect(product).not_to be_valid
    end
  end
end
