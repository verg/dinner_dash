require 'spec_helper'

describe Item do
  describe "title" do
    it "cannot be an empty string"
    it "must be unique"
  end

  describe "price_cents" do
    it 'must be greater than zero'
  end
end
