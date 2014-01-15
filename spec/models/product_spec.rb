require 'spec_helper'

describe Product do

  it { should have_many(:categories) }

  it "has a valid factory" do
    expect(FactoryGirl.build(:product)).to be_valid
  end

  describe "title" do
    it "must be present" do
      expect(Product.new(title: "")).to have(1).errors_on(:title)
      expect(Product.new).to have(1).errors_on(:title)
    end

    it "must be unique" do
      create(:product)
      expect(build(:product)).to have(1).errors_on(:title)
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
    it "must be a valid url" do
      expect(build(:product, photo: "not_a_url")).to have(1).errors_on(:photo)
      expect(build(:product, photo: "http://a-url.com")).to be_valid
    end
  end
end
