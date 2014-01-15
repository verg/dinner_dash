require 'spec_helper'

describe LineItem do
  it { should belong_to(:cart) }
  it { should belong_to(:product) }
end
