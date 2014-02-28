require 'spec_helper'

describe AdminDashboard do

  let(:dashboard) { AdminDashboard.new }

  it "gives access to all Categories" do
    category = create(:category)
    expect(dashboard.categories).to match_array([category])
  end

  it "gives access to all availible Products" do
    product = create(:product)
    retired_product = create(:product, available: false)

    expect(dashboard.products).to include(product)
    expect(dashboard.products).not_to include(retired_product)
  end

  it "provides access to all Orders" do
    order = create(:order)
    expect(dashboard.orders).to eq [order]
  end

  describe "#orders_filtered_by" do
    it "can have a status" do
      dashboard = AdminDashboard.new(order_status: "paid")
      expect(dashboard.orders_filtered_by).to eq :paid
      expect(dashboard.has_order_filter?).to be_true
    end

    it "defaults to no status" do
      expect(dashboard.orders_filtered_by).to eq :none
      expect(dashboard.has_order_filter?).to be_false
    end
  end
end
