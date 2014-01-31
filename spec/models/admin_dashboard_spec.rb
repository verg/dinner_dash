require 'spec_helper'

describe AdminDashboard do
  it "gives access to all Categories" do
    category = create(:category)
    dashboard = AdminDashboard.new
    expect(dashboard.categories).to match_array([category])
  end
end
