require 'spec_helper'

describe Item do
  it "has a valid factory" do
    expect(FactoryGirl.build(:item)).to be_valid
  end

  describe "title" do
    it "must be present" do
      expect(Item.new(title: "")).to have(1).errors_on(:title)
      expect(Item.new).to have(1).errors_on(:title)
    end

    it "must be unique" do
      create(:item)
      expect(build(:item)).to have(1).errors_on(:title)
    end
  end

  describe "price_cents" do
    it 'must be greater than zero' do
      expect(build(:item, price_cents: -1)).to have(1).errors_on(:price_cents)
    end

    it "must be an integer" do
      expect(build(:item, price_cents: 0.1)).to have(1).errors_on(:price_cents)
    end
  end
end
