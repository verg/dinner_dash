require 'spec_helper'

describe Category do
  it { should have_many(:products) }
  it { should have_many(:products) }

  it "isn't valid without a :name" do
    no_name = Category.new(name: "")
    expect(no_name).not_to be_valid
  end
end
