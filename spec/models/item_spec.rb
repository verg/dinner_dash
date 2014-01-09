require 'spec_helper'

describe Item do
  it "has a valid factory" do
    expect(FactoryGirl.build(:item)).to be_valid
  end

  describe "title" do
    it "cannot be an empty string"
    it "must be unique"
  end

  describe "price_cents" do
    it 'must be greater than zero'
  end
end
